#!/usr/bin/env bash
# Open Grind Premium — Build Environment Checker
# Run on any Linux machine to determine if it can compile the APK.
# Usage: chmod +x check-build-env.sh && ./check-build-env.sh
#
# Note: For private repo one-liner, use a personal access token:
# curl -fsSL "https://raw.githubusercontent.com/Pottstim/open-grind-premium/main/scripts/check-build-env.sh?token=$(gh auth token)" | bash

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'
BOLD='\033[1m'

PASS=0
FAIL=0
WARN=0

check_pass() { echo -e "  ${GREEN}✅${NC} $1"; PASS=$((PASS+1)); }
check_fail() { echo -e "  ${RED}❌${NC} $1"; FAIL=$((FAIL+1)); }
check_warn() { echo -e "  ${YELLOW}⚠️${NC}  $1"; WARN=$((WARN+1)); }
check_info() { echo -e "  ${BLUE}ℹ️${NC}  $1"; }

echo -e "\n${BOLD}${BLUE}Open Grind Premium — Build Environment Check${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

# ── System ──────────────────────────────────────────────────────────────
echo -e "${BOLD}System${NC}"

ARCH=$(uname -m 2>/dev/null || echo "unknown")
if [[ "$ARCH" == "x86_64" ]]; then
    check_pass "Architecture: x86_64 (supported)"
elif [[ "$ARCH" == "aarch64" ]]; then
    check_warn "Architecture: aarch64 (not tested, may work)"
else
    check_fail "Architecture: $ARCH (need x86_64)"
fi

KERNEL=$(uname -r 2>/dev/null || echo "unknown")
check_info "Kernel: $KERNEL"

OS_ID=$(grep -oP '(?<=^ID=).+' /etc/os-release 2>/dev/null | tr -d '"' || echo "unknown")
OS_VER=$(grep -oP '(?<=^VERSION_ID=).+' /etc/os-release 2>/dev/null | tr -d '"' || echo "")
check_info "OS: ${OS_ID} ${OS_VER}"

# ── CPU ─────────────────────────────────────────────────────────────────
echo -e "\n${BOLD}CPU${NC}"

CPU_CORES=$(nproc 2>/dev/null || grep -c ^processor /proc/cpuinfo 2>/dev/null || echo "1")
if [[ "$CPU_CORES" -ge 4 ]]; then
    check_pass "Cores: ${CPU_CORES} (good)"
elif [[ "$CPU_CORES" -ge 2 ]]; then
    check_warn "Cores: ${CPU_CORES} (minimum — builds will be slow)"
else
    check_fail "Cores: ${CPU_CORES} (need at least 2)"
fi

CPU_MODEL=$(grep "model name" /proc/cpuinfo 2>/dev/null | head -1 | cut -d: -f2 | xargs || echo "unknown")
check_info "Model: $CPU_MODEL"

# ── Memory ──────────────────────────────────────────────────────────────
echo -e "\n${BOLD}Memory${NC}"

MEM_TOTAL_KB=$(grep MemTotal /proc/meminfo 2>/dev/null | awk '{print $2}' || echo "0")
MEM_TOTAL_GB=$((MEM_TOTAL_KB / 1024 / 1024))
MEM_AVAILABLE_KB=$(grep MemAvailable /proc/meminfo 2>/dev/null | awk '{print $2}' || echo "0")
MEM_AVAILABLE_GB=$((MEM_AVAILABLE_KB / 1024 / 1024))

SWAP_TOTAL_KB=$(grep SwapTotal /proc/meminfo 2>/dev/null | awk '{print $2}' || echo "0")
SWAP_TOTAL_GB=$((SWAP_TOTAL_KB / 1024 / 1024))

if [[ "$MEM_TOTAL_GB" -ge 12 ]]; then
    check_pass "RAM: ${MEM_TOTAL_GB}GB total / ${MEM_AVAILABLE_GB}GB free (excellent)"
elif [[ "$MEM_TOTAL_GB" -ge 8 ]]; then
    check_pass "RAM: ${MEM_TOTAL_GB}GB total / ${MEM_AVAILABLE_GB}GB free (good)"
elif [[ "$MEM_TOTAL_GB" -ge 4 ]]; then
    if [[ "$SWAP_TOTAL_GB" -ge 4 ]]; then
        check_pass "RAM: ${MEM_TOTAL_GB}GB + ${SWAP_TOTAL_GB}GB swap (workable with swap)"
    else
        check_warn "RAM: ${MEM_TOTAL_GB}GB ${SWAP_TOTAL_GB}GB swap — likely OOM without swap (need 4GB+ swap)"
    fi
else
    check_fail "RAM: ${MEM_TOTAL_GB}GB (need at least 4GB)"
fi

# ── Disk ────────────────────────────────────────────────────────────────
echo -e "\n${BOLD}Disk${NC}"

DISK_AVAIL_GB=$(df -BG / 2>/dev/null | tail -1 | awk '{print $4}' | tr -d 'G' || echo "0")
DISK_TOTAL_GB=$(df -BG / 2>/dev/null | tail -1 | awk '{print $2}' | tr -d 'G' || echo "0")

if [[ "$DISK_AVAIL_GB" -ge 100 ]]; then
    check_pass "Disk: ${DISK_AVAIL_GB}GB free / ${DISK_TOTAL_GB}GB total (excellent)"
elif [[ "$DISK_AVAIL_GB" -ge 30 ]]; then
    check_pass "Disk: ${DISK_AVAIL_GB}GB free / ${DISK_TOTAL_GB}GB total (good)"
elif [[ "$DISK_AVAIL_GB" -ge 15 ]]; then
    check_warn "Disk: ${DISK_AVAIL_GB}GB free — tight but workable (~12GB needed)"
else
    check_fail "Disk: ${DISK_AVAIL_GB}GB free (need at least 15GB)"
fi

# ── Rust ────────────────────────────────────────────────────────────────
echo -e "\n${BOLD}Rust Toolchain${NC}"

if command -v rustc &>/dev/null; then
    RUST_VER=$(rustc --version 2>/dev/null | awk '{print $2}')
    check_pass "rustc: ${RUST_VER}"
    if command -v cargo &>/dev/null; then
        check_pass "cargo: $(cargo --version 2>/dev/null | awk '{print $2}')"
    else
        check_fail "cargo: not found (broken Rust install)"
    fi
else
    check_fail "Rust: not found"
    check_info "Install: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
fi

# ── Bun ─────────────────────────────────────────────────────────────────
echo -e "\n${BOLD}Bun${NC}"

if command -v bun &>/dev/null; then
    check_pass "Bun: $(bun --version 2>/dev/null)"
else
    check_fail "Bun: not found"
    check_info "Install: curl -fsSL https://bun.sh/install | bash"
fi

# ── Java ────────────────────────────────────────────────────────────────
echo -e "\n${BOLD}Java${NC}"

if command -v java &>/dev/null; then
    JAVA_VER=$(java -version 2>&1 | head -1 | grep -oP '"\K[^"]+' || echo "unknown")
    JAVA_MAJOR=$(echo "$JAVA_VER" | cut -d. -f1)
    if [[ "$JAVA_MAJOR" -ge 21 ]]; then
        check_pass "Java: ${JAVA_VER} (JDK ${JAVA_MAJOR})"
    elif [[ "$JAVA_MAJOR" -ge 17 ]]; then
        check_warn "Java: ${JAVA_VER} (JDK ${JAVA_MAJOR} — 21 recommended)"
    else
        check_fail "Java: ${JAVA_VER} (need JDK 17+)"
    fi
    if [[ -n "${JAVA_HOME:-}" ]]; then
        check_pass "JAVA_HOME: ${JAVA_HOME}"
    else
        check_warn "JAVA_HOME: not set"
    fi
else
    check_fail "Java: not found"
    check_info "Install: sdk install java 21.0.7-zulu (via sdkman)"
fi

# ── Android SDK ──────────────────────────────────────────────────────────
echo -e "\n${BOLD}Android SDK${NC}"

SDK_DIR=""
if [[ -n "${ANDROID_HOME:-}" && -d "$ANDROID_HOME" ]]; then
    SDK_DIR="$ANDROID_HOME"
elif [[ -d "/opt/android-sdk" ]]; then
    SDK_DIR="/opt/android-sdk"
elif [[ -d "$HOME/Android/Sdk" ]]; then
    SDK_DIR="$HOME/Android/Sdk"
fi

if [[ -n "$SDK_DIR" ]]; then
    check_pass "SDK: ${SDK_DIR}"
    [[ -d "$SDK_DIR/platforms/android-35" ]] && check_pass "Platform: android-35" || check_fail "Platform: android-35 missing"
    [[ -d "$SDK_DIR/build-tools/35.0.0" ]] && check_pass "Build Tools: 35.0.0" || check_fail "Build Tools: 35.0.0 missing"
    [[ -d "$SDK_DIR/ndk/28.1.13356709" ]] && check_pass "NDK: 28.1.13356709" || check_fail "NDK: 28.1.13356709 missing"
    [[ -f "$SDK_DIR/cmake/3.31.6/bin/cmake" ]] && check_pass "CMake: 3.31.6" || check_warn "CMake: 3.31.6 missing"
else
    check_fail "Android SDK: not found (set ANDROID_HOME or install to /opt/android-sdk)"
fi

# ── Tauri CLI ────────────────────────────────────────────────────────────
echo -e "\n${BOLD}Tauri CLI${NC}"

TAURI_VER=$(cargo tauri --version 2>/dev/null | head -1 || echo "")
if [[ -n "$TAURI_VER" ]]; then
    check_pass "Tauri CLI: ${TAURI_VER}"
else
    check_warn "Tauri CLI: not found (will auto-install via cargo)"
    check_info "Manual: cargo install tauri-cli --version '^2.0.0'"
fi

# ── Network ──────────────────────────────────────────────────────────────
echo -e "\n${BOLD}Network${NC}"

if curl -sSf --connect-timeout 5 -o /dev/null https://crates.io/ 2>/dev/null; then
    check_pass "crates.io: reachable"
else
    check_fail "crates.io: unreachable (required for cargo)"
fi

if curl -sSf --connect-timeout 5 -o /dev/null https://dl.google.com/dl/android/maven2/ 2>/dev/null; then
    check_pass "Google Maven: reachable"
else
    check_warn "Google Maven: unreachable (Android deps will fail)"
fi

# ── GitHub ──────────────────────────────────────────────────────────────
echo -e "\n${BOLD}GitHub${NC}"

if curl -sSf --connect-timeout 5 -o /dev/null https://api.github.com/repos/Pottstim/open-grind-premium 2>/dev/null; then
    check_pass "Repo: accessible"
elif curl -sSf --connect-timeout 5 -o /dev/null https://github.com 2>/dev/null; then
    check_warn "GitHub: reachable but repo may be private (need auth)"
else
    check_warn "GitHub: unreachable (needed to clone repo)"
fi

# ── Summary ──────────────────────────────────────────────────────────────
echo -e "\n${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}Summary${NC}\n"

TOTAL=$((PASS + FAIL + WARN))
echo -e "  Pass: ${GREEN}${PASS}${NC}  Fail: ${RED}${FAIL}${NC}  Warn: ${YELLOW}${WARN}${NC}"

echo ""

if [[ "$FAIL" -eq 0 && "$WARN" -eq 0 ]]; then
    echo -e "  ${GREEN}${BOLD}✅ Fully ready to build Open Grind Premium.${NC}"
    echo -e "  ${GREEN}  Next: ./scripts/build-linux.sh all${NC}"
elif [[ "$FAIL" -eq 0 ]]; then
    echo -e "  ${YELLOW}${BOLD}⚠️  Can build with warnings.${NC}"
    echo -e "  ${YELLOW}  Review warnings. Build may be slow.${NC}"
    echo -e "  ${YELLOW}  Next: ./scripts/build-linux.sh all${NC}"
    EXIT_CODE=0
else
    echo -e "  ${RED}${BOLD}❌ NOT ready to build.${NC}"
    echo -e "  ${RED}  Fix the failures above first.${NC}"
    echo ""
    echo -e "  ${BOLD}Quick setup for fresh Debian/Ubuntu VPS:${NC}"
    echo -e "  ${BLUE}  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y${NC}"
    echo -e "  ${BLUE}  source \"\$HOME/.cargo/env\"${NC}"
    echo -e "  ${BLUE}  curl -fsSL https://bun.sh/install | bash && source ~/.bashrc${NC}"
    echo -e "  ${BLUE}  curl -fsSL https://get.sdkman.io | bash${NC}"
    echo -e "  ${BLUE}  source \"\$HOME/.sdkman/bin/sdkman-init.sh\" && sdk install java 21.0.7-zulu${NC}"
    echo -e "  ${BLUE}  sudo mkdir -p /opt/android-sdk && sudo chown \$USER:\$USER /opt/android-sdk${NC}"
    echo -e "  ${BLUE}  curl -fsSL \"https://dl.google.com/android/repository/commandlinetools-linux-14742923_latest.zip\" | tar -xz -C /opt/android-sdk --strip-components=1${NC}"
    echo -e "  ${BLUE}  yes | sdkmanager --install \"platforms;android-35\" \"build-tools;35.0.0\" \"ndk;28.1.13356709\" \"cmake;3.31.6\" \"platform-tools\"${NC}"
    echo -e "  ${BLUE}  cargo install tauri-cli --version '^2.0.0'${NC}"
    EXIT_CODE=1
fi

echo ""
exit ${EXIT_CODE:-0}
