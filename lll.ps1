# lll.ps1 — List Light Layers
# A simple recursive folder lister with filtering and size info
# Author: Light — https://github.com/scaven-light

param (
    [string]$base = ".",
    [int]$depth = 0,
    [string]$filter = "*",
    [switch]$ShowSize,
    [Alias('h')] [switch]$help
)

if ($help) {
    Write-Output @"
Usage: lll.ps1 [-base PATH] [-depth N] [-filter PATTERN] [-ShowSize] [-help|-h]

  -base       Base folder to list (default: current folder)
  -depth      How many levels deep to list subdirectories (default: 0 = only base)
  -filter     Wildcard pattern to filter items (default: *)
  -ShowSize   Show size for files and folders (slow for large folders)
  -help, -h   Show this help and exit

Examples:
  ./lll.ps1 -depth 2
  ./lll.ps1 -base 'C:\Projects' -filter '*.ps1' -ShowSize
  Or just
  ./lll . 2 '*.py'

This script lists files and folders with optional size, depth and filtering.
"@
    exit
}

# Convert size to human-readable string
function Convert-Size {
    param([long]$bytes)
    if ($bytes -ge 1TB) { return "{0:N2} TB" -f ($bytes / 1TB) }
    elseif ($bytes -ge 1GB) { return "{0:N2} GB" -f ($bytes / 1GB) }
    elseif ($bytes -ge 1MB) { return "{0:N2} MB" -f ($bytes / 1MB) }
    elseif ($bytes -ge 1KB) { return "{0:N2} KB" -f ($bytes / 1KB) }
    else { return "$bytes B" }
}

function Get-Size {
    param([Object]$item)
    if ($item.PSIsContainer) {
        return (Get-ChildItem $item.FullName -Recurse -File -Filter $filter -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    } else {
        return $item.Length
    }
}

function Walk-Talk {
    param([Object[]]$items)

    foreach ($item in $items) {
        $name = if ($item.PSIsContainer) { "$($item.Name)\" } else { $item.Name }
        if ($ShowSize) {
            $size = Get-Size $item
            $sizeStr = Convert-Size $size
            Write-Output "  $name  [$sizeStr]"
        } else {
            Write-Output "  $name"
        }
    }
}

# Output items in a directory
function Show-Items {
    param([string]$path)

    $items = Get-ChildItem -LiteralPath $path -Filter $filter -Force -ErrorAction SilentlyContinue
    if ($items.Count -eq 0) {
        return
    }
    Write-Output ""
    Write-Output "$path\"
    Walk-Talk $items
}


$resolvedBase = (Resolve-Path -LiteralPath $base).Path
$MicrosoftDepth = $depth - 1

# Optional info header
$infoParts = @()
if ($depth -gt 0) { $infoParts += "depth $depth" }
if ($filter -ne "*") { $infoParts += "filter '$filter'" }
if ($ShowSize) { $infoParts += "sizes [" + (Convert-Size (Get-Size (Get-Item $resolvedBase))) +"]" }
$infoText = if ($infoParts.Count -gt 0) { " (" + ($infoParts -join ", ") + ")" } else { "" }
Write-Output ""
Write-Output "Listing contents$infoText"

# Show top-level
Write-Output "$resolvedBase\"
$topItems = Get-ChildItem -LiteralPath $resolvedBase -Filter $filter -Force -ErrorAction SilentlyContinue
if ($topItems.Count -gt 0) {
  Walk-Talk $topItems
}

# Show subdirectories up to depth
if ($depth -gt 0) {
    Get-ChildItem -LiteralPath $resolvedBase -Directory -Recurse -Depth $MicrosoftDepth -Force -ErrorAction SilentlyContinue | ForEach-Object {
        Show-Items $_.FullName
    }
}
