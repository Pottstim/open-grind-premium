# Building Open Grind

Open Grind supports reproducible builds. Details TBA.

## Prerequisites

### All platforms

- [Bun](https://bun.sh)
- [Rust](https://rustup.rs)
- [Tauri CLI](https://tauri.app/start/prerequisites/)

### Android

- [Android Studio](https://developer.android.com/studio) with SDK and NDK
- Java 21
- Environment variables:

```bash
export JAVA_HOME=/path/to/java
export ANDROID_HOME=$HOME/Library/Android/sdk
export NDK_HOME=$ANDROID_HOME/ndk/
```

## Setup

```bash
# Install dependencies
bun ci

# Verify Rust toolchain
rustup show
```

## Building

```bash
# Desktop
bun run build

# Android
bun run tauri android build
```

## Reproducibility

All toolchain versions are pinned. Do not bump them without updating this document.

| Component              | Version            | Pinned in                           |
| ---------------------- | ------------------ | ----------------------------------- |
| Rust                   | `1.95.0`           | `rust-toolchain.toml`               |
| Tauri CLI              | see `package.json` | `package.json` devDependencies      |
| Android Gradle Plugin  | `8.13.2`           | `build.gradle.kts` (buildSrc + app) |
| Gradle                 | `8.14.5`           | `gradle-wrapper.properties`         |
| Kotlin                 | `1.9.25`           | `build.gradle.kts`                  |

### Verifying the Gradle wrapper jar

The Gradle wrapper jar is committed at `src-tauri/gen/android/gradle/wrapper/gradle-wrapper.jar`.

```bash
shasum -a 256 src-tauri/gen/android/gradle/wrapper/gradle-wrapper.jar
```

Compare against [Gradle's published checksums](https://gradle.org/release-checksums/) for Gradle 8.14.5 (`7d3a4ac4de1c32b59bc6a4eb8ecb8e612ccd0cf1ae1e99f66902da64df296172`)

### Cargo

```bash
cargo build
```

Never run `cargo update` without intentionally bumping dependencies and reviewing the diff.

### JS dependencies

Always use `bun ci`, not `bun install` or `bun i`.