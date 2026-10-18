Add-Type -AssemblyName System.Drawing

$img1Path = "C:\Users\jedeann\.gemini\antigravity\brain\052500a0-f2da-4bb0-bf30-3de0be627bb6\.user_uploaded\media_1792341280550_02872b28.jpg"
$img2Path = "C:\Users\jedeann\.gemini\antigravity\brain\052500a0-f2da-4bb0-bf30-3de0be627bb6\.user_uploaded\media_1792341280551_c6464c57.jpg"
$img3Path = "C:\Users\jedeann\.gemini\antigravity\brain\052500a0-f2da-4bb0-bf30-3de0be627bb6\.user_uploaded\media_1792341321813_feaf76ba.jpg"

$bmp1 = [System.Drawing.Bitmap]::FromFile($img1Path)
$bmp2 = [System.Drawing.Bitmap]::FromFile($img2Path)
$bmp3 = [System.Drawing.Bitmap]::FromFile($img3Path)

Write-Output "Image 1 (Cast): $($bmp1.Width) x $($bmp1.Height)"
Write-Output "Image 2 (Logo): $($bmp2.Width) x $($bmp2.Height)"
Write-Output "Image 3 (Poster with Wolves): $($bmp3.Width) x $($bmp3.Height)"

$bmp1.Dispose()
$bmp2.Dispose()
$bmp3.Dispose()

