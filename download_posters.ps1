
$ErrorActionPreference = "Continue"

$folder = Join-Path $PSScriptRoot "assets\images"

$movies = @(
    @{ Title = "Spider-Man Across the Spider-Verse"; File = "spider_verse.jpg"; Query = "Spider-Man: Across the Spider-Verse 2023 poster" },
    @{ Title = "Parasite"; File = "parasite.jpg"; Query = "Parasite 2019 film poster" },
    @{ Title = "The Matrix"; File = "the_matrix.jpg"; Query = "The Matrix 1999 film poster" },
    @{ Title = "Mission Impossible Fallout"; File = "mission_impossible_fallout.jpg"; Query = "Mission Impossible Fallout 2018 poster" }
)

foreach ($movie in $movies) {
    $path = Join-Path $folder $movie.File

    if (Test-Path $path) {
        Write-Host "[SUDAH ADA] $($movie.Title)" -ForegroundColor Yellow
        continue
    }

    try {
        $query = [uri]::EscapeDataString($movie.Query)
        $url = "https://www.google.com/search?tbm=isch&q=$query"

        $html = (Invoke-WebRequest -Uri $url -Headers @{
            "User-Agent" = "Mozilla/5.0"
        }).Content

        $matches = [regex]::Matches(
            $html,
            'https?://[^"&\\ ]+\.(?:jpg|jpeg|png)(?:\?[^"&\\ ]*)?'
        )

        $downloaded = $false

        foreach ($match in $matches) {
            $imageUrl = [System.Net.WebUtility]::HtmlDecode($match.Value)

            try {
                Invoke-WebRequest -Uri $imageUrl -OutFile $path -Headers @{
                    "User-Agent" = "Mozilla/5.0"
                }

                if ((Test-Path $path) -and (Get-Item $path).Length -gt 5000) {
                    Write-Host "[BERHASIL] $($movie.Title)" -ForegroundColor Green
                    $downloaded = $true
                    break
                }

                Remove-Item $path -Force -ErrorAction SilentlyContinue
            }
            catch {
                Remove-Item $path -Force -ErrorAction SilentlyContinue
            }
        }

        if (-not $downloaded) {
            Write-Host "[GAGAL] $($movie.Title)" -ForegroundColor Red
        }
    }
    catch {
        Write-Host "[GAGAL] $($movie.Title): $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`nSELESAI" -ForegroundColor Cyan
