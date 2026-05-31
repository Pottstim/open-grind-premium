# Open Grind Premium — Windows Build Script
# Builds desktop app (native) or Android APK (via WSL2)
#
# Usage:
#   .\scripts\build-windows.ps1 -Mode desktop     # Desktop only (native)
#   .\scripts\build-windows.ps1 -Mode android     # Android via WSL2
#   .\scripts\build-windows.ps1 -Mode all         # Both

param(
    [ValidateSet("desktop", "android", "all")]
    [string]$Mode = "desktop"
)

$ErrorActionPreference = "Stop"

function Write-Log($msg) { Write-Host "[BUILD] $msg" -ForegroundColor Green }
function Write-Warn($msg) { Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Write-Err($msg) { Write-Host "[ERROR] $msg" -ForegroundColor Red; exit 1 }

# Verify prerequisites
function Test-Command($name) {
    if (!(Get-Command $name -ErrorAction SilentlyContinue)) {
        Write-Err "$name not found. Install it first."
    }
}

Test-Command rustc
Test-Command bun

Write-Log "Rust: $(rustc --version)"
Write-Log "Bun: $(bun --version)"

$ProjectRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $ProjectRoot

Write-Log "Installing Bun dependencies..."
bun install

Write-Log "Building frontend (Vite + SvelteKit)..."
bun run build

switch ($Mode) {
    "desktop" {
        Write-Log "Building Tauri desktop app..."
        bun run tauri build
        Write-Log "Desktop build complete!"
        Write-Log "Binary: src-tauri\target\release\open-grind.exe"
    }
    "android" {
        Write-Log "Checking WSL2..."
        $wslCheck = wsl --list --quiet 2>&1
        if ($LASTEXITCODE -ne 0) {
            Write-Err "WSL2 not available. Install: wsl --install -d Ubuntu-24.04"
        }

        Write-Log "Building Android APK via WSL2..."
        $wslPath = wsl wslpath -u ($ProjectRoot -replace '\\', '/')
        wsl -d Ubuntu-24.04 -e bash -c "cd $wslPath && bun run tauri android init 2>/dev/null; bun run tauri android build"

        $apkPath = "src-tauri\gen\android\app\build\outputs\apk\universal\universal-release.apk"
        if (Test-Path $apkPath) {
            Write-Log "Android build complete!"
            Write-Log "APK: $apkPath"
        } else {
            Write-Err "APK not found at expected path. Check WSL2 build output above."
        }
    }
    "all" {
        Write-Log "Building desktop (native)..."
        bun run tauri build
        Write-Log "Desktop build complete!"

        Write-Log "Building Android via WSL2..."
        $wslPath = wsl wslpath -u ($ProjectRoot -replace '\\', '/')
        wsl -d Ubuntu-24.04 -e bash -c "cd $wslPath && bun run tauri android init 2>/dev/null; bun run tauri android build"
        Write-Log "All builds complete!"
    }
}
