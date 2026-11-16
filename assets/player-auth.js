(function (root, factory) {
 const api = factory();
 if (typeof module === 'object' && module.exports) module.exports = api;
 root.PlayerAuth = api;
})(typeof globalThis === 'undefined' ? this : globalThis, function () {
 const AUTH_BASE_URL = 'https://identitytoolkit.googleapis.com/v1/accounts';
 const TOKEN_BASE_URL = 'https://securetoken.googleapis.com/v1/token';
 const EMAIL_DOMAIN = '@couriers.wordscape.invalid';

 function credentialsForCourier(courierKey) {
  return {
   email: `${courierKey}${EMAIL_DOMAIN}`,
   password: `streamlined-${courierKey}`
  };
 }

 async function authRequest(operation, apiKey, body, fetchImpl) {
  const response = await fetchImpl(
   `${AUTH_BASE_URL}:${operation}?key=${encodeURIComponent(apiKey)}`,
   {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body)
   }
  );
  const result = await response.json();
  return { ok: response.ok, result };
 }

 function errorCode(result) {
  return result && result.error && result.error.message
   ? result.error.message.split(' ')[0]
   : '';
 }

 function createSession(auth, expectedEmail) {
  if (!auth.localId || !auth.idToken || !auth.refreshToken || auth.email !== expectedEmail) {
   throw new Error('Firebase returned an invalid player authentication response.');
  }
  return {
   uid: auth.localId,
   email: auth.email,
   idToken: auth.idToken,
   refreshToken: auth.refreshToken,
   expiresAt: Date.now() + Number(auth.expiresIn) * 1000 - 60000
  };
 }

 async function authenticateCourier(courierKey, apiKey, fetchImpl = fetch) {
  const credentials = credentialsForCourier(courierKey);
  const requestBody = { ...credentials, returnSecureToken: true };
  const signIn = await authRequest('signInWithPassword', apiKey, requestBody, fetchImpl);
  if (signIn.ok) {
   return { session: createSession(signIn.result, credentials.email), isNew: false };
  }

  const signInCode = errorCode(signIn.result);
  if (signInCode !== 'EMAIL_NOT_FOUND' && signInCode !== 'INVALID_LOGIN_CREDENTIALS') {
   throw new Error(`Player sign-in failed (${signInCode || 'unknown error'}).`);
  }

  const signUp = await authRequest('signUp', apiKey, requestBody, fetchImpl);
  if (signUp.ok) {
   return { session: createSession(signUp.result, credentials.email), isNew: true };
  }

  if (errorCode(signUp.result) === 'EMAIL_EXISTS') {
   const retry = await authRequest('signInWithPassword', apiKey, requestBody, fetchImpl);
   if (retry.ok) {
    return { session: createSession(retry.result, credentials.email), isNew: false };
   }
   throw new Error('This courier identity already has a different sign-in credential. Contact the host for help.');
  }

  const code = errorCode(signUp.result);
  throw new Error(`Player account setup failed (${code || 'unknown error'}).`);
 }

 async function refreshSession(session, apiKey, fetchImpl = fetch) {
  const response = await fetchImpl(`${TOKEN_BASE_URL}?key=${encodeURIComponent(apiKey)}`, {
   method: 'POST',
   headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
   body: new URLSearchParams({
    grant_type: 'refresh_token',
    refresh_token: session.refreshToken
   })
  });
  const auth = await response.json();
  if (!response.ok) {
   throw new Error(`Player token refresh failed (${errorCode(auth) || response.status}).`);
  }
  if (auth.user_id !== session.uid) {
   throw new Error('Refreshed player token identity did not match the signed-in courier.');
  }
  return {
   uid: auth.user_id,
   email: session.email,
   idToken: auth.id_token,
   refreshToken: auth.refresh_token,
   expiresAt: Date.now() + Number(auth.expires_in) * 1000 - 60000
  };
 }

 return { authenticateCourier, credentialsForCourier, refreshSession };
});
