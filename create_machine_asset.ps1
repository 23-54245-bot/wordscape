Add-Type -AssemblyName System.Drawing

$zone1Path = "c:\Users\jedeann\OneDrive\Documents\streamlined-wordscape-web\assets\zone1.jpg"
$destPath = "c:\Users\jedeann\OneDrive\Documents\streamlined-wordscape-web\assets\machine.png"

$bmp = [System.Drawing.Bitmap]::FromFile($zone1Path)
$rect = New-Object System.Drawing.Rectangle(200, 150, 320, 320)
$cropBmp = New-Object System.Drawing.Bitmap(320, 320, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($cropBmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$path = New-Object System.Drawing.Drawing2D.GraphicsPath
$path.AddEllipse(0, 0, 320, 320)
$g.SetClip($path)
$destRect = New-Object System.Drawing.Rectangle(0, 0, 320, 320)
$g.DrawImage($bmp, $destRect, $rect, [System.Drawing.GraphicsUnit]::Pixel)
$g.Dispose()

$cropBmp.Save($destPath, [System.Drawing.Imaging.ImageFormat]::Png)
$cropBmp.Dispose()
$bmp.Dispose()
Write-Output "Created: $destPath"

