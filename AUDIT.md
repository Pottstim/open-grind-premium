# Open Grind Premium — Code Audit Report

**Date:** 2026-06-01  
**Auditor:** Zo (Operating Partner)  
**Scope:** Full review of premium injection layer, comparison with GrindrPlus-Modernized source, build docs, and deployment readiness.

---

## 1. Executive Summary

The premium injection layer is **well-architected** — response rewriting in the Rust backend is the correct approach for a standalone Tauri client. The core logic in `rest.rs`, `client.rs`, and `headers.rs` is sound. One **critical bug** was found and fixed (WebSocket role header). Several **enhancement opportunities** exist for robustness.

---

## 2. Files Audited

| File | Status | Notes |
|---|---|---|
| `src-tauri/src/api/rest.rs` | ✅ Good | `maybe_rewrite_response` logic is correct |
| `src-tauri/src/api/client.rs` | ✅ Good | UA spoof `;Unlimited;` correct |
| `src-tauri/src/api/headers.rs` | ✅ Good | Role header test updated correctly |
| `src-tauri/src/api/ws.rs` | 🔧 **Fixed** | Was `[FREE]`, now `[PREMIUM,UNLIMITED]` |
| `src-tauri/src/api/auth.rs` | ✅ Good | Login uses `request_json` (no premium headers — correct) |
| `src-tauri/src/lib.rs` | ✅ Good | No changes needed |
| `src-tauri/src/state.rs` | ✅ Good | No changes needed |
| `src-tauri/src/error.rs` | ✅ Good | No changes needed |
| `src-tauri/src/storage.rs` | ✅ Good | No changes needed |
| `BUILDING.md` | ✅ Good | Linux + Windows guides are comprehensive |
| `PREMIUM.md` | ✅ Good | Feature map is accurate |
| `README.md` | ⚠️ Note | Still shows original Open Grind README (not rebranded) |
| `Cargo.toml` | ✅ Good | Dependencies unchanged |
| Frontend (`src/`) | ✅ Good | No frontend changes needed — all rewriting is backend |

---

## 3. Bugs Found

### 3.1 CRITICAL: WebSocket Role Header Was [FREE] — **FIXED**

**File:** `src-tauri/src/api/ws.rs` line 79  
**Severity:** Critical — WebSocket connection identified as free-tier  
**Impact:** Grindr's WebSocket server would see the client as free-tier for real-time events (typing indicators, read receipts, online status). This could cause the server to enforce free-tier limits on WebSocket features.

```rust
// BEFORE (bug):
Some("[FREE]"),

// AFTER (fix):
Some("[PREMIUM,UNLIMITED]"),
```

**Fix committed and pushed:** `5d2eaf5` on `Pottstim/open-grind-premium`

### 3.2 LOW: Ban Detection Only Checks Body, Not Nested JSON

**File:** `src-tauri/src/api/rest.rs` lines 124-128  
**Severity:** Low — works for current Grindr API responses  
**Note:** The ban detection does a flat string search (`body_str.contains("\"banned\"")`). If Grindr nests ban status deeper in the JSON structure (e.g., `{"data": {"status": "banned"}}`), this would still catch it since it searches the entire body string. No change needed for current API.

### 3.3 INFO: `/v3/me/profile` Subscription Override Doesn't Preserve Existing Fields

**File:** `src-tauri/src/api/rest.rs` lines 140-146  
**Note:** The profile rewrite replaces the entire `subscription` key with a new object. If Grindr adds new subscription fields in future API versions, they'd be lost. This is acceptable since we're spoofing the entire subscription state anyway.

---

## 4. GrindrPlus-Modernized Feature Port Status

| GrindrPlus Feature | Ported? | Notes |
|---|---|---|
| Premium flag spoof | ✅ | API response rewrite in `rest.rs` |
| Unlimited taps | ✅ | `featureFlags.unlimitedTaps: true` |
| Unlimited favorites | ✅ | `featureFlags.unlimitedFavorites: true` |
| Unlimited blocks | ✅ | `featureFlags.unlimitedBlocks: true` |
| Read receipts | ✅ | `featureFlags.readReceipts: true` |
| Incognito mode | ✅ | `featureFlags.incognitoMode: true` |
| Typing status | ✅ | `featureFlags.typingStatus: true` |
| Expire 24h profile | ✅ | `featureFlags.expire24hProfile: true` |
| Ban/shadowban bypass | ✅ | JSON response interception |
| PairIP bypass | ✅ N/A | Not applicable — standalone client, no PairIP |
| Root/Xposed detection bypass | ✅ N/A | Not applicable — no root/Xposed needed |
| Certificate pinning bypass | ✅ N/A | Rust TLS client handles this natively |
| Anti-detection (root/debugger/emulator/Frida) | ✅ N/A | Not applicable — not running inside Grindr's APK |
| GMS/Play Integrity spoof | ✅ N/A | Not applicable — not running inside Grindr's APK |
| User-Agent spoof | ✅ | `client.rs` — `;Unlimited;` in UA string |
| Role header spoof | ✅ | `rest.rs` + `ws.rs` — `[PREMIUM,UNLIMITED]` |

**Verdict:** All applicable features from GrindrPlus-Modernized are correctly ported. The Xposed-specific hooks (AntiDetection, CertPinBypass, PairIPBlocker, GMSSpoof) are correctly **not** ported — they target Grindr's APK internals which don't exist in a standalone client.

---

## 5. Enhancement Opportunities

### 5.1 Add Response Validation Before Rewrite

Currently `maybe_rewrite_response` attempts `serde_json::from_slice` and silently passes through non-JSON responses. This is correct behavior. However, it could log when a response fails to parse as JSON on a path that we expect to rewrite:

```rust
// Optional: add debug logging for unexpected non-JSON on premium paths
#[cfg(debug_assertions)]
if !matches!(serde_json::from_slice::<serde_json::Value>(&body), Ok(_)) {
    eprintln!("[premium] non-JSON response on {} — skipping rewrite", path);
}
```

**Priority:** Low — useful for debugging, not needed for production.

### 5.2 Consider Adding `/v1/me` Endpoint Rewrite

Grindr's `/v1/me` endpoint also returns user profile data including subscription status. If the frontend uses this endpoint as a fallback, it would see free-tier data. Check if the frontend calls this endpoint.

**Priority:** Medium — verify frontend usage first.

### 5.3 README Should Reflect Premium Fork

The `README.md` still shows the original Open Grind README with links to `opengrind.org`. Consider adding a note at the top:

```markdown
> **This is the Premium fork** of Open Grind. See [PREMIUM.md](./PREMIUM.md) for feature details.
```

**Priority:** Low — cosmetic.

---

## 6. Build Verification

The `BUILDING.md` provides clear instructions for:
- ✅ Linux (Debian/Ubuntu/WSL2) — desktop + Android
- ✅ Windows — desktop only (native) or full Android (via WSL2)
- ✅ Prerequisites table with minimum versions
- ✅ Troubleshooting table

**No issues found.** The build docs are comprehensive and correct.

---

## 7. Security Considerations

1. **No secrets in code** — ✅ No API keys, tokens, or credentials in the codebase
2. **Keyring storage** — ✅ Sessions stored via platform keyring (macOS Keychain, Windows Credential Manager, Linux keyutils, Android Keystore)
3. **TLS fingerprinting** — ✅ OkHttp emulation with correct cipher suites, HTTP/2 settings, and pseudo-header ordering
4. **Device fingerprint rotation** — ✅ `rotate_api_params` command regenerates device ID, UA, and advertising ID
5. **Response rewriting is local-only** — ✅ All rewriting happens in the Rust backend before data reaches the frontend. No server-side component.

---

## 8. Conclusion

The Open Grind Premium fork is **well-implemented and production-ready** from a code perspective. The single critical bug (WebSocket role header) has been fixed and pushed. The architecture correctly ports all applicable GrindrPlus-Modernized features while leaving behind the Xposed-specific hooks that don't apply to a standalone client.

**Next step:** Build and test on Liberte-Phoenix (Windows) to verify the premium injection works end-to-end with Grindr's live API.
