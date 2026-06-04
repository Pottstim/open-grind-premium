#!/usr/bin/env bash
set -euo pipefail

# Open Grind Premium — Build Environment Checker
# Run on any Linux machine to determine if it can compile the APK.
# Usage: curl -fsSL <raw-url> | bash   OR   chmod +x check-build-env.sh && ./check-build-env.sh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'
BOLD='\033[1m'

PASS=0
FAIL=0
WARN=0

check_pass() { echo -e "  ${GREEN}✅${NC} $1"; ((PASS++)); }
check_fail() { echo -e "  ${RED}❌${NC} $1"; ((FAIL++)); }
check_warn() { echo -e "  ${YELLOW}⚠️${NC}  $1"; ((WARN++)); }

echo -e "\n${BOLD}${BLUE}Open Grind Premium — Build Environment Check${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

# ── System ──────────────────────────────────────────────────────────────
echo -e "${BOLD}System${NC}"

ARCH=$(uname -m)
if [[ "$ARCH" == "x86_64" ]]; then
    check_pass "Architecture: $ARCH (supported)"
else
    check_fail "Architecture: $ARCH (need x86_64)"
fi

KERNEL=$(uname -r)
check_pass "Kernel: $KERNEL"

# ── CPU ─────────────────────────────────────────────────────────────────
echo -e "\n${BOLD}CPU${NC}"

CPU_CORES=$(nproc 2>/dev/null || grep -c ^processor /proc/cpuinfo 2>/dev/null || echo "1")
if [[ "$CPU_CORES" -ge 4 ]]; then
    check_pass "Cores: $CPU_CORES (recommended)"
elif [[ "$CPU_CORES" -ge 2 ]]; then
    check_warn "Cores: $CPU_CORES (minimum — build will be slow)"
else
    check_fail "Cores: $CPU_CORES (need at least 2)"
fi

CPU_MODEL=$(grep "model name" /proc/cpuinfo 2>/dev/null | head -1 | cut -d: -f2 | xargs || echo "unknown")
echo -e "  ${BLUE}ℹ️${NC}  Model: $CPU_MODEL"

# ── Memory ──────────────────────────────────────────────────────────────
echo -e "\n${BOLD}Memory${NC}"

MEM_TOTAL_KB=$(grep MemTotal /proc/meminfo 2>/dev/null | awk '{print $2}' || echo "0")
MEM_TOTAL_GB=$((MEM_TOTAL_KB / 1024 / 1024))
MEM_AVAILABLE_KB=$(grep MemAvailable /proc/meminfo 2>/dev/null | awk '{print $2}' || echo "0")
MEM_AVAILABLE_GB=$((MEM_AVAILABLE_KB / 1024 / 1024))

SWAP_TOTAL_KB=$(grep SwapTotal /proc/meminfo 2>/dev/null | awk '{print $2}' || echo "0")
SWAP_TOTAL_GB=$((SWAP_TOTAL_KB / 1024 / 1024))

if [[ "$MEM_TOTAL_GB" -ge 8 ]]; then
    check_pass "RAM: ${MEM_TOTAL_GB} GB total, ${MEM_AVAILABLE_GB} GB available (recommended)"
elif [[ "$MEM_TOTAL_GB" -ge 4 ]]; then
    if [[ "$SWAP_TOTAL_GB" -ge 2 ]]; then
        check_pass "RAM: ${MEM_TOTAL_GB} GB + ${SWAP_TOTAL_GB} GB swap (workable)"
    else
        check_warn "RAM: ${MEM_TOTAL_GB} GB, no swap — will likely OOM during cargo build"
    fi
else
    check_fail "RAM: ${MEM_TOTAL_GB} GB (need at least 4 GB)"
fi

if [[ "$SWAP_TOTAL_GB" -gt 0 ]]; then
    check_pass "Swap: ${SWAP_TOTAL_GB} GB"
else
    check_warn "Swap: none (strongly recommended for ≤8 GB RAM)"
fi

# ── Disk ────────────────────────────────────────────────────────────────
echo -e "\n${BOLD}Disk${NC}"

DISK_AVAIL_KB=$(df -k / 2>/dev/null | tail -1 | awk '{print $4}' || df -k . 2>/dev/null | tail -1 | awk '{print $4}' || echo "0")
DISK_AVAIL_GB=$((DISK_AVAIL_KB / 1024 / 1024))

if [[ "$DISK_AVAIL_GB" -ge 50 ]]; then
    check_pass "Free disk: ${DISK_AVAIL_GB} GB (recommended)"
elif [[ "$DISK_AVAIL_GB" -ge 30 ]]; then
    check_warn "Free disk: ${DISK_AVAIL_GB} GB (minimum — tight but workable)"
else
    check_fail "Free disk: ${DISK_AVAIL_GB} GB (need at least 30 GB)"
fi

DISK_TYPE=$(lsblk -d -o NAME,ROTA,TYPE 2>/dev/null | grep -v "ROTA" | head -1 | awk '{print $2}' || echo "?")
if [[ "$DISK_TYPE" == "0" ]]; then
    check_pass "Disk type: SSD/NVMe (fast builds)"
elif [[ "$DISK_TYPE" == "1" ]]; then
    check_warn "Disk type: HDD (builds will be slower)"
else
    echo -e "  ${BLUE}ℹ️${NC}  Disk type: unknown"
fi

# ── Rust ────────────────────────────────────────────────────────────────
echo -e "\n${BOLD}Rust Toolchain${NC}"

if command -v rustc &>/dev/null; then
    RUST_VER=$(rustc --version 2>/dev/null | awk '{print $2}')
    check_pass "Rust: $RUST_VER"
    if command -v cargo &>/dev/null; then
        check_pass "Cargo: $(cargo --version 2>/dev/null | awk '{print $2}')"
    else
        check_fail "Cargo: not found (install rustup)"
    fi
else
    check_fail "Rust: not found"
    echo -e "  ${BLUE}ℹ️${NC}  Install: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
fi

# ── Bun ─────────────────────────────────────────────────────────────────
echo -e "\n${BOLD}Bun${NC}"

if command -v bun &>/dev/null; then
    BUN_VER=$(bun --version 2>/dev/null)
    check_pass "Bun: $BUN_VER"
else
    check_fail "Bun: not found"
    echo -e "  ${BLUE}ℹ️${NC}  Install: curl -fsSL https://bun.sh/install | bash"
fi

# ── Java ────────────────────────────────────────────────────────────────
echo -e "\n${BOLD}Java${NC}"

if command -v java &>/dev/null; then
    JAVA_VER=$(java -version 2>&1 | head -1 | grep -oP '"\K[^"]+' || echo "unknown")
    JAVA_MAJOR=$(echo "$JAVA_VER" | cut -d. -f1)
    if [[ "$JAVA_MAJOR" -ge 21 ]]; then
        check_pass "Java: $JAVA_VER (JDK $JAVA_MAJOR — meets requirement)"
    elif [[ "$JAVA_MAJOR" -ge 17 ]]; then
        check_warn "Java: $JAVA_VER (JDK $JAVA_MAJOR — works but 21 recommended)"
    else
        check_fail "Java: $JAVA_VER (need JDK 17+, 21 recommended)"
    fi
    if [[ -n "${JAVA_HOME:-}" ]]; then
        check_pass "JAVA_HOME: $JAVA_HOME"
    else
        check_warn "JAVA_HOME: not set (may cause Android SDK issues)"
    fi
else
    check_fail "Java: not found"
    echo -e "  ${BLUE}ℹ️${NC}  Install: curl -fsSL https://get.sdkman.io | bash && sdk install java 21.0.7-zulu"
fi

# ── Android SDK ─────────────────────────────────────────────────────────
echo -e "\n${BOLD}Android SDK${NC}"

ANDROID_SDK_FOUND=false

if [[ -n "${ANDROID_HOME:-}" && -d "$ANDROID_HOME" ]]; then
    check_pass "ANDROID_HOME: $ANDROID_HOME"
    ANDROID_SDK_FOUND=true
elif [[ -d "/opt/android-sdk" ]]; then
    check_pass "Android SDK: /opt/android-sdk (found)"
    ANDROID_SDK_FOUND=true
elif [[ -d "$HOME/Android/Sdk" ]]; then
    check_pass "Android SDK: $HOME/Android/Sdk (found)"
    ANDROID_SDK_FOUND=true
else
    check_fail "Android SDK: not found"
    echo -e "  ${BLUE}ℹ️${NC}  Will be auto-installed by build script"
fi

if [[ "$ANDROID_SDK_FOUND" == true ]]; then
    SDK_DIR="${ANDROID_HOME:-/opt/android-sdk}"
    [[ ! -d "$SDK_DIR" ]] && SDK_DIR="$HOME/Android/Sdk"

    # Check platform
    if [[ -d "$SDK_DIR/platforms/android-35" ]]; then
        check_pass "Platform: android-35 ✅"
    elif ls "$SDK_DIR/platforms/" 2>/dev/null | grep -q "android-"; then
        INSTALLED=$(ls "$SDK_DIR/platforms/" 2>/dev/null | grep "android-" | tr '\n' ' ')
        check_warn "Platform: $INSTALLED (need android-35)"
    else
        check_fail "Platform: none installed"
    fi

    # Check build-tools
    if [[ -d "$SDK_DIR/build-tools/35.0.0" ]]; then
        check_pass "Build Tools: 35.0.0 ✅"
    elif ls "$SDK_DIR/build-tools/" 2>/dev/null | grep -q ""; then
        INSTALLED=$(ls "$SDK_DIR/build-tools/" 2>/dev/null | tr '\n' ' ')
        check_warn "Build Tools: $INSTALLED (need 35.0.0)"
    else
        check_fail "Build Tools: none installed"
    fi

    # Check NDK
    if [[ -d "$SDK_DIR/ndk/28.1.13356709" ]]; then
        check_pass "NDK: 28.1.13356709 ✅"
    elif ls "$SDK_DIR/ndk/" 2>/dev/null | grep -q ""; then
        INSTALLED=$(ls "$SDK_DIR/ndk/" 2>/dev/null | tr '\n' ' ')
        check_warn "NDK: $INSTALLED (need 28.1.13356709)"
    else
        check_fail "NDK: none installed"
    fi

    # Check CMake
    if [[ -f "$SDK_DIR/cmake/3.31.6/bin/cmake" ]]; then
        check_pass "CMake: 3.31.6 ✅"
    elif ls "$SDK_DIR/cmake/" 2>/dev/null | grep -q ""; then
        INSTALLED=$(ls "$SDK_DIR/cmake/" 2>/dev/null | tr '\n' ' ')
        check_warn "CMake: $INSTALLED (need 3.31.6)"
    else
        check_fail "CMake: none installed"
    fi
fi

# ── Tauri CLI ───────────────────────────────────────────────────────────
echo -e "\n${BOLD}Tauri CLI${NC}"

if command -v cargo-tauri &>/dev/null || cargo tauri --version &>/dev/null 2>&1; then
    TAURI_VER=$(cargo tauri --version 2>/dev/null | head -1 || echo "installed")
    check_pass "Tauri CLI: $TAURI_VER"
else
    check_warn "Tauri CLI: not found (will be installed via cargo)"
    echo -e "  ${BLUE}ℹ️${NC}  Install: cargo install tauri-cli --version '^2.0.0'"
fi

# ── Network ─────────────────────────────────────────────────────────────
echo -e "\n${BOLD}Network${NC}"

# Test crates.io (Rust package registry)
if curl -sSf --connect-timeout 5 https://crates.io/ -o /dev/null 2>/dev/null; then
    check_pass "crates.io: reachable"
else
    check_fail "crates.io: unreachable (cargo needs this)"
fi

# Test Google Maven (Android dependencies)
if curl -sSf --connect-timeout 5 https://dl.google.com/dl/android/maven2/ -o /dev/null 2>/dev/null; then
    check_pass "Google Maven: reachable"
else
    check_warn "Google Maven: unreachable (may slow Android builds)"
fi

# Test npm registry (Bun fallback)
if curl -sSf --connect-timeout 5 https://registry.npmjs.org/ -o /dev/null 2>/dev/null; then
    check_pass "npm registry: reachable"
else
    check_warn "npm registry: unreachable"
fi

# ── Summary ─────────────────────────────────────────────────────────────
echo -e "\n${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}Summary${NC}\n"

TOTAL=$((PASS + FAIL + WARN))
echo -e "  Pass: ${GREEN}$PASS${NC}  Fail: ${RED}$FAIL${NC}  Warn: ${YELLOW}$WARN${NC}  Total: $TOTAL"

echo ""

if [[ "$FAIL" -eq 0 && "$WARN" -eq 0 ]]; then
    echo -e "  ${GREEN}${BOLD}✅ This machine is fully ready to build Open Grind Premium.${NC}"
    echo -e "  ${GREEN}Run: ./scripts/build-linux.sh all${NC}"
elif [[ "$FAIL" -eq 0 ]]; then
    echo -e "  ${YELLOW}${BOLD}⚠️  This machine can build but has warnings.${NC}"
    echo -e "  ${YELLOW}Review warnings above. Build may be slow or need swap.${NC}"
    echo -e "  ${YELLOW}Run: ./scripts/build-linux.sh all${NC}"
else
    echo -e "  ${RED}${BOLD}❌ This machine is NOT ready to build.${NC}"
    echo -e "  ${RED}Fix the failures above before attempting a build.${NC}"
    echo ""
    echo -e "  ${BOLD}Quick fix for a fresh Debian/Ubuntu VPS:${NC}"
    echo -e "  ${BLUE}  # Install Rust${NC}"
    echo -e "  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y"
    echo -e "  source \"\$HOME/.cargo/env\""
    echo -e "  ${BLUE}  # Install Bun${NC}"
    echo -e "  curl -fsSL https://bun.sh/install | bash"
    echo -e "  source ~/.bashrc"
    echo -e "  ${BLUE}  # Install Java 21${NC}"
    echo -e "  curl -fsSL https://get.sdkman.io | bash"
    echo -e "  source \"\$HOME/.sdkman/bin/sdkman-init.sh\""
    echo -e "  sdk install java 21.0.7-zulu"
    echo -e "  ${BLUE}  # Install Android SDK${NC}"
    echo -e "  sudo mkdir -p /opt/android-sdk && sudo chown \$USER:\$USER /opt/android-sdk"
    echo -e "  curl -fsSL \"https://dl.google.com/android/repository/commandlinetools-linux-14742923_latest.zip\" -o /tmp/cmdline-tools.zip"
    echo -e "  cd /opt/android-sdk && unzip -q /tmp/cmdline-tools.zip"
    echo -e "  mkdir -p cmdline-tools/latest && mv cmdline-tools/{bin,lib} cmdline-tools/latest/"
    echo -e "  yes | sdkmanager --install \"platforms;android-35\" \"build-tools;35.0.0\" \"ndk;28.1.13356709\" \"cmake;3.31.6\" \"platform-tools\""
    echo -e "  ${BLUE}  # Install Tauri CLI${NC}"
    echo -e "  cargo install tauri-cli --version '^2.0.0'"
    echo -e "  ${BLUE}  # Then build${NC}"
    echo -e "  ./scripts/build-linux.sh all"
fi

echo ""
