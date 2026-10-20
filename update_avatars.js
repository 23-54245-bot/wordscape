/**
 * update_avatars.js
 * ─────────────────────────────────────────────────────────────
 * Run this script ANY TIME you add/remove images from:
 *   assets/avatars/
 *
 * It will:
 *   1. Scan the avatars folder for .jpg/.jpeg/.png/.webp files
 *   2. Generate a pretty character name from the filename
 *   3. Write assets/avatars.json  ← read by the game at runtime
 *   4. Commit & push to GitHub automatically
 *
 * Usage:
 *   node update_avatars.js
 * ─────────────────────────────────────────────────────────────
 */

const fs   = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const REPO       = 'C:\\Users\\jedeann\\OneDrive\\Documents\\streamlined-wordscape-web';
const AVATAR_DIR = path.join(REPO, 'assets', 'avatars');
const JSON_OUT   = path.join(REPO, 'assets', 'avatars.json');
const EXTS       = new Set(['.jpg', '.jpeg', '.png', '.webp', '.gif']);

// Known name overrides — edit this map when adding new characters
// Key = filename (no extension, lowercase), Value = display name
const NAME_MAP = {
  'fm_diamond':     'Baby Diamond',
  'fm_junior':      'Junior',
  'fm_tulip':       'Tulip',
  'fm_toady':       'Pigeon Toady',
  'fm_nate':        'Nate Gardner',
  'fm_hunter':      'Hunter',
  // Add new entries here, e.g.:
  // 'fm_boss':     'Boss Baby',
};

// Pretty-name: checks NAME_MAP first, then auto-generates from filename
function prettyName(filename) {
  const key = path.basename(filename, path.extname(filename)).toLowerCase();
  if (NAME_MAP[key]) return NAME_MAP[key];
  return key
    .replace(/^fm_/i, '')
    .replace(/[_-]/g, ' ')
    .replace(/\b\w/g, c => c.toUpperCase());
}

// Scan folder
const files = fs.readdirSync(AVATAR_DIR)
  .filter(f => EXTS.has(path.extname(f).toLowerCase()))
  .sort();

if (files.length === 0) {
  console.error('No image files found in', AVATAR_DIR);
  process.exit(1);
}

const avatars = files.map(f => ({
  name: prettyName(f),
  img:  `assets/avatars/${f}`
}));

fs.writeFileSync(JSON_OUT, JSON.stringify(avatars, null, 2), 'utf8');
console.log(`\nWrote ${JSON_OUT}`);
console.log(`\n${avatars.length} characters found:`);
avatars.forEach((a, i) => console.log(`  ${i+1}. ${a.name}  (${a.img})`));

// Git add + commit + push
try {
  execSync(`git -C "${REPO}" add assets/avatars assets/avatars.json`, { stdio: 'inherit' });
  execSync(`git -C "${REPO}" commit -m "chore: update avatar list (${avatars.length} characters)"`, { stdio: 'inherit' });
  execSync(`git -C "${REPO}" push origin main`, { stdio: 'inherit' });
  console.log('\n✅ Pushed to GitHub! Live in ~1 minute.');
} catch (e) {
  // If nothing changed, git commit returns non-zero — that's fine
  if (e.message && e.message.includes('nothing to commit')) {
    console.log('\nNo changes to commit (avatar list unchanged).');
  } else {
    console.error('\nGit error:', e.message);
  }
}
