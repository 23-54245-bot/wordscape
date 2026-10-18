Add-Type -AssemblyName System.Drawing

$img1Path = "C:\Users\jedeann\.gemini\antigravity\brain\052500a0-f2da-4bb0-bf30-3de0be627bb6\.user_uploaded\media_1792341280550_02872b28.jpg"
$img2Path = "C:\Users\jedeann\.gemini\antigravity\brain\052500a0-f2da-4bb0-bf30-3de0be627bb6\.user_uploaded\media_1792341280551_c6464c57.jpg"
$img3Path = "C:\Users\jedeann\.gemini\antigravity\brain\052500a0-f2da-4bb0-bf30-3de0be627bb6\.user_uploaded\media_1792341321813_feaf76ba.jpg"

$bmp1 = [System.Drawing.Bitmap]::FromFile($img1Path)
$bmp2 = [System.Drawing.Bitmap]::FromFile($img2Path)
$bmp3 = [System.Drawing.Bitmap]::FromFile($img3Path)

function CropAndSaveBadge($srcBmp, $rect, $destPath, $circular) {
    $cropBmp = New-Object System.Drawing.Bitmap($rect.Width, $rect.Height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($cropBmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic

    if ($circular) {
        $path = New-Object System.Drawing.Drawing2D.GraphicsPath
        $path.AddEllipse(0, 0, $rect.Width, $rect.Height)
        $g.SetClip($path)
    }

    $destRect = New-Object System.Drawing.Rectangle(0, 0, $rect.Width, $rect.Height)
    $g.DrawImage($srcBmp, $destRect, $rect, [System.Drawing.GraphicsUnit]::Pixel)
    $g.Dispose()

    $cropBmp.Save($destPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $cropBmp.Dispose()
    Write-Output "Created: $destPath"
}

# 1. STREAMLINED Logo
$logoRect = New-Object System.Drawing.Rectangle(20, 150, 984, 260)
CropAndSaveBadge $bmp2 $logoRect "c:\Users\jedeann\OneDrive\Documents\streamlined-wordscape-web\assets\logo.png" $false

# 2. Baby (from Poster img3: bottom center)
# Poster size: 713 x 1024. Baby head is approx x=180 to 535, y=710 to 1020
$babyRect = New-Object System.Drawing.Rectangle(185, 715, 350, 305)
CropAndSaveBadge $bmp3 $babyRect "c:\Users\jedeann\OneDrive\Documents\streamlined-wordscape-web\assets\baby.png" $true

# 3. Junior the Stork (from Poster img3: bottom-left looking up)
# Junior head: x=0 to 380, y=550 to 920
$juniorRect = New-Object System.Drawing.Rectangle(0, 550, 360, 360)
CropAndSaveBadge $bmp3 $juniorRect "c:\Users\jedeann\OneDrive\Documents\streamlined-wordscape-web\assets\junior.png" $true

# 4. Tulip (from Poster img3: bottom-right)
# Tulip head: x=380 to 713, y=500 to 860
$tulipRect = New-Object System.Drawing.Rectangle(380, 500, 330, 360)
CropAndSaveBadge $bmp3 $tulipRect "c:\Users\jedeann\OneDrive\Documents\streamlined-wordscape-web\assets\tulip.png" $true

# 5. Wolves (from Poster img3: top-right)
# Wolves: x=480 to 713, y=160 to 520
$wolvesRect = New-Object System.Drawing.Rectangle(480, 160, 233, 360)
CropAndSaveBadge $bmp3 $wolvesRect "c:\Users\jedeann\OneDrive\Documents\streamlined-wordscape-web\assets\wolves.png" $true

# 6. Family (from Cast img1: top-right)
# Cast size: 735 x 391. Nate and parents are at x=420 to 735, y=0 to 390
$familyRect = New-Object System.Drawing.Rectangle(580, 0, 155, 300)
CropAndSaveBadge $bmp1 $familyRect "c:\Users\jedeann\OneDrive\Documents\streamlined-wordscape-web\assets\family.png" $true

# 7. Zone 4 (Neighborhood & family background)
$zone4Rect = New-Object System.Drawing.Rectangle(0, 0, 735, 391)
$zone4Bmp = New-Object System.Drawing.Bitmap(735, 391)
$gZ4 = [System.Drawing.Graphics]::FromImage($zone4Bmp)
$gZ4.DrawImage($bmp1, 0, 0, 735, 391)
$gZ4.Dispose()
$zone4Bmp.Save("c:\Users\jedeann\OneDrive\Documents\streamlined-wordscape-web\assets\zone4.jpg", [System.Drawing.Imaging.ImageFormat]::Jpeg)
$zone4Bmp.Dispose()
Write-Output "Created: assets\zone4.jpg"

$bmp1.Dispose()
$bmp2.Dispose()
$bmp3.Dispose()

