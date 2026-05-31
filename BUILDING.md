# Building Open Grind Premium

This document covers building the Open Grind Premium fork on **Linux** and **Windows**. The Tauri desktop app is the recommended way to test the premium injection works before attempting an Android build.

## Prerequisites

| Tool | Minimum Version | Purpose |
|---|---|---|
| Rust | 1.93+ | Tauri backend compilation |
| Bun | 1.2+ | Frontend dependency management & bundling |
| Java | 21+ | Android SDK tooling |
| Android SDK | android-35 | Android platform tools |
| CMake | 3.31.6 | NDK native build |
| NDK | 28.1.13356709 | Android native compilation |

---

## Linux (Debian/Ubuntu/WSL2)

### 1. Install Rust
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"
rustc --version  # verify 1.93+
```

### 2. Install Bun
```bash
curl -fsSL https://bun.sh/install | bash
source ~/.bashrc
bun --version
```

### 3. Install Java 21
```bash
curl -fsSL https://get.sdkman.io | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install java 21.0.7-zulu
java -version  # verify 21+
```

### 4. Install Android SDK
```bash
export ANDROID_HOME=/opt/android-sdk
sudo mkdir -p $ANDROID_HOME
sudo chown $USER:$USER $ANDROID_HOME

# Download command line tools
curl -fsSL "https://dl.google.com/android/repository/commandlinetools-linux-14742923_latest.zip" \
  -o /tmp/cmdline-tools.zip
cd $ANDROID_HOME && unzip -q /tmp/cmdline-tools.zip
mkdir -p cmdline-tools/latest
mv cmdline-tools/{bin,lib} cmdline-tools/latest/

# Install SDK components
export JAVA_HOME="$HOME/.sdkman/candidates/java/current"
export PATH="$JAVA_HOME/bin:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
yes | sdkmanager --install \
  "platforms;android-35" \
  "build-tools;35.0.0" \
  "ndk;28.1.13356709" \
  "cmake;3.31.6" \
  "platform-tools"

# Persist environment
cat >> ~/.bashrc << 'ENVEOF'
export JAVA_HOME="$HOME/.sdkman/candidates/java/current"
export ANDROID_HOME=/opt/android-sdk
export ANDROID_NDK_HOME=$ANDROID_HOME/ndk/28.1.13356709
export PATH="$JAVA_HOME/bin:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_NDK_HOME:$PATH"
ENVEOF
```

### 5. Build Desktop (recommended for testing)
```bash
cd /path/to/open-grind
bun install
bun run build               # Build SvelteKit frontend
bun run tauri build         # Build Tauri desktop app
```
Output: `src-tauri/target/release/open-grind` (Linux binary)

### 6. Build Android APK
```bash
bun run tauri android init   # First time only
bun run tauri android build  # Build signed APK
```
Output: `src-tauri/gen/android/app/build/outputs/apk/universal/universal-release.apk`

---

## Windows

### Option A: Native Windows (Desktop only)

#### 1. Install Rust
Download from https://rustup.rs/ or use winget:
```powershell
winget install Rustlang.Rustup
# Restart terminal after install
rustup default stable
```

#### 2. Install Bun
```powershell
powershell -c "irm bun.sh/install.ps1 | iex"
```

#### 3. Install Tauri prerequisites
```powershell
# WebView2 (usually pre-installed on Win10/11)
# If missing: https://go.microsoft.com/fwlink/p/?LinkId=2124703

# MSVC Build Tools (via Visual Studio 2022 Installer)
# Workload: "Desktop development with C++"
winget install Microsoft.VisualStudio.2022.BuildTools
```

#### 4. Build Desktop
```powershell
cd C:\path\to\open-grind
bun install
bun run build               # Build SvelteKit frontend
bun run tauri build         # Build Tauri desktop app
```
Output: `src-tauri/target/release/open-grind.exe`

### Option B: WSL2 (Full Android build)

WSL2 gives you a full Linux environment on Windows with access to the Android SDK.

#### 1. Install WSL2
```powershell
wsl --install -d Ubuntu-24.04
# Restart, then set up Ubuntu user
```

#### 2. Inside WSL2
```bash
# Follow the Linux instructions above exactly
# Your Windows files are accessible at /mnt/c/
cd /mnt/c/path/to/open-grind
```

#### 3. Build Android from WSL2
```bash
# Same as Linux step 6
bun run tauri android init
bun run tauri android build
```

---

## Feature Summary

This fork adds premium feature injection at the API interception layer, ported from GrindrPlus-Modernized:

| Feature | Endpoint(s) | Method |
|---|---|---|
| User-Agent spoof | All requests | `Free` → `Unlimited` |
| Role header | All authorized requests | `[FREE]` → `[PREMIUM,UNLIMITED]` |
| Bootstrap premium | `/v3/bootstrap` | Inject UNLIMITED role + all feature flags |
| Entitlements | `/v1/entitlements` | Set `rightNow` (view count) to 999 |
| Profile premium | `/v3/me/profile` | Inject premium subscription object |
| Subscriptions | `/v4/subscriptions` | Inject UNLIMITED subscription tier |
| Ban bypass | Any endpoint | Intercept `banned`/`suspended`/`restricted` JSON responses → 200 OK |

## Troubleshooting

| Error | Solution |
|---|---|
| `cargo: command not found` | Run `source $HOME/.cargo/env` |
| `JAVA_HOME not set` | Run `source $HOME/.sdkman/bin/sdkman-init.sh` |
| OOM during build | Close other apps; build desktop only first |
| `sdkmanager: command not found` | Check ANDROID_HOME path and cmdline-tools structure |
| `tauri: command not found` | Install Tauri CLI: `cargo install tauri-cli --version "^2.0.0"` |
| Vite build hangs | Low memory — try with `--max-old-space-size=3584` |
| Android NDK not found | Verify `ANDROID_NDK_HOME` points to `ndk/28.1.13356709` |
