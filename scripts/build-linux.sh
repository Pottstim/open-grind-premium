#!/usr/bin/env bash
set -euo pipefail

# Open Grind Premium — Linux Build Script
# Builds desktop app + Android APK

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log()  { echo -e "${GREEN}[BUILD]${NC} $*"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
err()  { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }

# Load environment
export JAVA_HOME="${JAVA_HOME:-/usr/lib/jvm/java-17-openjdk-amd64}"
export ANDROID_HOME="${ANDROID_HOME:-/opt/android-sdk}"
export ANDROID_NDK_HOME="${ANDROID_NDK_HOME:-$ANDROID_HOME/ndk/27.0.12077973}"
export PATH="$JAVA_HOME/bin:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_NDK_HOME:$PATH"

# Verify prerequisites
command -v rustc >/dev/null 2>&1 || err "Rust not found. Install: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
command -v bun >/dev/null 2>&1 || err "Bun not found. Install: curl -fsSL https://bun.sh/install | bash"
command -v java >/dev/null 2>&1 || err "Java not found. Install via sdkman: sdk install java 21.0.7-zulu"

log "Rust: $(rustc --version)"
log "Bun: $(bun --version)"
log "Java: $(java -version 2>&1 | head -1)"
log "ANDROID_HOME: $ANDROID_HOME"
log "ANDROID_NDK_HOME: $ANDROID_NDK_HOME"

MODE="${1:-desktop}"
cd "$(dirname "$0")/.."

log "Installing Bun dependencies..."
bun install

log "Building frontend (Vite + SvelteKit)..."
bun run build

case "$MODE" in
  desktop)
    log "Building Tauri desktop app..."
    bun run tauri build
    log "✅ Desktop build complete!"
    log "Binary: src-tauri/target/release/open-grind"
    ;;
  android)
    log "Initializing Android project (if needed)..."
    if [ ! -d "src-tauri/gen/android" ]; then
      bun run tauri android init
    fi
    log "Building Android APK..."
    bun run tauri android build
    log "✅ Android build complete!"
    log "APK: src-tauri/gen/android/app/build/outputs/apk/universal/release/app-universal-release.apk"
    ;;
  all)
    log "Building desktop..."
    bun run tauri build
    log "Initializing Android (if needed)..."
    if [ ! -d "src-tauri/gen/android" ]; then
      bun run tauri android init
    fi
    log "Building Android APK..."
    bun run tauri android build
    log "✅ All builds complete!"
    ;;
  *)
    echo "Usage: $0 {desktop|android|all}"
    exit 1
    ;;
esac
