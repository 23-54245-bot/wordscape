Add-Type -AssemblyName System.Drawing

function Convert-ToTransparentPng($srcPath, $destPath) {
    Write-Output "Processing $srcPath -> $destPath"
    $bmp = [System.Drawing.Bitmap]::FromFile($srcPath)
    $w = $bmp.Width
    $h = $bmp.Height
    $outBmp = New-Object System.Drawing.Bitmap($w, $h, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

    for ($y = 0; $y -lt $h; $y++) {
        for ($x = 0; $x -lt $w; $x++) {
            $p = $bmp.GetPixel($x, $y)
            if ($p.R -ge 238 -and $p.G -ge 238 -and $p.B -ge 238) {
                $outBmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
            } elseif ($p.R -ge 218 -and $p.G -ge 218 -and $p.B -ge 218) {
                $maxVal = [Math]::Max($p.R, [Math]::Max($p.G, $p.B))
                $alpha = [int](255 * (240 - $maxVal) / 22)
                if ($alpha -lt 0) { $alpha = 0 }
                if ($alpha -gt 255) { $alpha = 255 }
                $outBmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($alpha, $p.R, $p.G, $p.B))
            } else {
                $outBmp.SetPixel($x, $y, $p)
            }
        }
    }
    $bmp.Dispose()
    $outBmp.Save($destPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $outBmp.Dispose()
    Write-Output "Saved $destPath successfully."
}

Convert-ToTransparentPng 'C:\Users\jedeann\.gemini\antigravity\brain\052500a0-f2da-4bb0-bf30-3de0be627bb6\baby_png_1792341227388.jpg' 'c:\Users\jedeann\OneDrive\Documents\streamlined-wordscape-web\assets\baby.png'
Convert-ToTransparentPng 'C:\Users\jedeann\.gemini\antigravity\brain\052500a0-f2da-4bb0-bf30-3de0be627bb6\junior_png_1792341257898.jpg' 'c:\Users\jedeann\OneDrive\Documents\streamlined-wordscape-web\assets\junior.png'
Convert-ToTransparentPng 'C:\Users\jedeann\.gemini\antigravity\brain\052500a0-f2da-4bb0-bf30-3de0be627bb6\tulip_png_1792341280480.jpg' 'c:\Users\jedeann\OneDrive\Documents\streamlined-wordscape-web\assets\tulip.png'
