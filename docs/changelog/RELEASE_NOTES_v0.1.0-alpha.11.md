# Release Notes - v0.1.0-alpha.11

We are pleased to announce the release of **Open Grind Premium v0.1.0-alpha.11**. This version focuses on critical stability improvements, enhanced Android build support, and infrastructure fixes to ensure a smoother development and release cycle.

## 🚀 Key Improvements

### 1. Backend Stability & Performance
*   **Async Recursion Resolution:** Fixed a critical issue in `src-tauri/src/api/rest.rs` where asynchronous recursion in the `request_raw` function could lead to potential stack overflows or runtime hangs. This was resolved by introducing a static `request_raw_internal` function that correctly handles state sharing via `Arc<GrindrClient>`.
*   **AppState Refactoring:** Refactored `AppState` to hold an `Arc<GrindrClient>`. This architectural change aligns with Rust best practices for sharing state across asynchronous tasks, improving memory safety and thread management.
*   **Dependency Pinning:** Pinned the `time` crate to version `0.3.51` to resolve a breaking change in the `cookie` crate that was preventing the project from compiling in certain environments.

### 2. Android Build & Signing
*   **Signed APK Generation:** Successfully implemented a workflow for generating signed Android builds. This release includes a signed APK (`app-arm64-release.apk`) verified with `jarsigner`.
*   **Keystore Configuration:** Established a secure keystore configuration using `release.jks` and `keystore.properties`, laying the groundwork for consistent and secure release packaging.
*   **Version Alignment:** Synchronized the `src-tauri/Cargo.toml` version with the release tag to ensure accurate version reporting within the application.

### 3. CI/CD Infrastructure
*   **Workflow Fix:** Identified and addressed a build failure in the GitHub Actions pipeline caused by a missing `clippy` component in the Rust toolchain. The `build-apk.yml` workflow has been updated to include all necessary components for automated verification and testing.

## 🛠 Bug Fixes
*   **`ws.rs`:** Resolved errors related to the non-existent `ws_buffer` field in `AppState`.
*   **`storage.rs`:** Fixed return type mismatches in secret management and corrected permission handling by properly importing `PermissionsExt`.
*   **`lib.rs`:** Fixed an initialization error by providing the required `PathBuf` to the keyring setup.
*   **`headers.rs`:** Cleaned up unresolved imports and removed legacy header references.

## 📦 Deliverables
*   **Source Code:** Available on the `main` branch of the GitHub repository.
*   **Android APK:** `app-arm64-release.apk` (Signed, arm64-v8a).

## ⚠️ Known Issues & Notes
*   **Manual Workflow Update:** Due to permission constraints, the fix for the GitHub Actions workflow file must be applied manually to the repository to enable automated builds.
*   **Self-Signed Certificate:** The release APK is signed with a self-signed certificate. You may need to bypass security warnings when installing the APK on your device.

---
*For more information, please visit the [Open Grind Premium GitHub Repository](https://github.com/Pottstim/open-grind-premium).*
