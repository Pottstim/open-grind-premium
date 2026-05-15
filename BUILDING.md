# Building Open Grind

Open Grind ships a [Nix flake](./flake.nix) that pins the entire Android toolchain — Rust, the JDK, the Android SDK, the NDK, Gradle, and Bun — so any contributor on Linux or macOS can produce a identical build in an indentical environment.

## Prerequisites

- [Nix](https://nixos.org/download) >= 2.18

No other dependencies are needed.

## Quickstart

```bash
nix run .#build-android
```

Output: `src-tauri/gen/android/app/build/outputs/apk/universal/release/`.

If you use [direnv](https://direnv.net/), the bundled [.envrc](./.envrc) activates the dev shell automatically when you `cd` into the repository.

## Signing

Signing is fully opt-in and contributor-local. Do not commit anything about your keystore.

1. Create a JKS once with `keytool`:
```bash
keytool -genkey -v \
  -keystore ~/.config/open-grind/release.jks \
  -alias open-grind \
  -keyalg EC \
  -groupname secp256r1 \
  -sigalg SHA256withECDSA \
  -validity 20000
```
2. Copy [contrib/keystore.properties.example](./contrib/keystore.properties.example) to a private location, such as `~/.config/open-grind/keystore.properties` and fill it in.
3. Build with:
```bash
OPEN_GRIND_KEYSTORE_PROPERTIES="~/.config/open-grind/keystore.properties" \
  nix run .#build-android
```

The build copies the properties file into the Gradle project for the duration of the build and removes it on exit. If `OPEN_GRIND_KEYSTORE_PROPERTIES` is unset, the release build runs unsigned.

## Reproducibility

Every input that affects the output bytes is pinned:

| Component             | Where it's pinned                        |
| --------------------- | ---------------------------------------- |
| nixpkgs               | `flake.lock`                             |
| Rust toolchain        | `rust-toolchain.toml`                    |
| JDK                   | `flake.nix` (`jdk21_headless`)           |
| Android SDK platform  | `flake.nix` (`platformVersions`)         |
| Android build-tools   | `flake.nix` (`buildToolsVersions`)       |
| Android NDK           | `flake.nix` (`ndkVersions`)              |
| Android Gradle Plugin | `src-tauri/gen/android/build.gradle.kts` |
| Gradle distribution   | `gradle-wrapper.properties`              |
| Kotlin                | `src-tauri/gen/android/build.gradle.kts` |
| Bun                   | nixpkgs pin (via `flake.lock`)           |
| Tauri CLI             | `package.json` / `bun.lock`              |
| JS deps               | `bun.lock`                               |
| Cargo deps            | `src-tauri/Cargo.lock`                   |

Do not bump any of these without updating this table in the same commit.

### Refreshing the lock

To pull newer nixpkgs/rust-overlay:

```bash
nix flake update
```

### Verifying the Gradle wrapper jar

The wrapper jar at `src-tauri/gen/android/gradle/wrapper/gradle-wrapper.jar` is committed and pinned to Gradle 8.14.5.

```bash
shasum -a 256 src-tauri/gen/android/gradle/wrapper/gradle-wrapper.jar
```

Compare against [Gradle's published checksums](https://gradle.org/release-checksums/) for 8.14.5 (`7d3a4ac4de1c32b59bc6a4eb8ecb8e612ccd0cf1ae1e99f66902da64df296172`).

## F-Droid

This build path is intended to be the F-Droid recipe. The reproducible
contract is:

- Clone at a tagged commit.
- `nix run .#build-android` with no `OPEN_GRIND_KEYSTORE_PROPERTIES` set.
- The resulting unsigned APK should match what F-Droid produces after
  stripping its own signing block.

If you observe drift, file an issue with the two APKs' `apksigner verify -v` and `diffoscope` output.

## Cargo / JS hygiene

Inside `nix develop`:

```bash
cargo build
bun ci
```

Never run `cargo update` or `bun update` without intentionally bumping dependencies and reviewing the diff.
