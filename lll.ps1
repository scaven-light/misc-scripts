param (
    [string]$base = ".",
    [int]$depth = 0,
    [string]$filter = "*"
)

$resolvedBase = (Resolve-Path -LiteralPath $base).Path
$colorInfo = "Green"
$colorRoot = "Cyan"
$colorDir = "Yellow"
$MicrosoftDepth = $depth - 1

# Build optional info summary
$infoParts = @()
if ($depth -gt 0) { $infoParts += "depth $depth" }
if ($filter -ne "*") { $infoParts += "filter '$filter'" }
$infoText = if ($infoParts.Count -gt 0) { " (" + ($infoParts -join ", ") + ")" } else { "" }

Write-Host "`nListing contents$infoText" -ForegroundColor $colorInfo

# List base folder if it has contents
Write-Host "$resolvedBase\" -ForegroundColor $colorRoot
$baseItems = Get-ChildItem -LiteralPath $resolvedBase -Filter $filter
if ($baseItems.Count -gt 0) {
    $baseItems | ForEach-Object {
        if ($_.PSIsContainer) {
            Write-Host "  $($_.Name)\" -ForegroundColor $colorDir
        } else {
            Write-Host "  $($_.Name)"
        }
    }
}

# Recurse if depth > 0
if ($depth -gt 0) {
    Get-ChildItem -Path $base -Recurse -Depth $MicrosoftDepth -Directory | ForEach-Object {
        $dir = $_.FullName
        $items = Get-ChildItem -LiteralPath $dir -Filter $filter
        if ($items.Count -gt 0) {
            Write-Host "`n$dir\" -ForegroundColor $colorRoot
            $items | ForEach-Object {
                if ($_.PSIsContainer) {
                    Write-Host "  $($_.Name)\" -ForegroundColor $colorDir
                } else {
                    Write-Host "  $($_.Name)"
                }
            }
        }
    }
}
