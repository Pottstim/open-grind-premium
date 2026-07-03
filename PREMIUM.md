# Premium Feature Injection

This fork of [Open Grind](https://github.com/VityaSchel/open-grind) adds
premium feature spoofing at the API interception layer, consolidating capabilities
from [GrindrPlus-Modernized](https://github.com/Pottstim/GrindrPlus-Modernized).

No root, no Xposed/LSPosed, no patching the official app required.

## How It Works

All API traffic flows through Open Grind's Rust backend (`GrindrClient`). The
`maybe_rewrite_response` function in `src-tauri/src/api/rest.rs` intercepts
JSON responses and injects premium data **before** it reaches the frontend. The
L-Grindr-Roles header is NO LONGER SENT — relying entirely on response rewriting
avoids detection. The client presents as an Unlimited-tier subscriber through
response injection only.

## Feature Map

| Feature | Hook Point | File | Description |
|---|---|---|---|
| **User-Agent spoof** | Outbound headers | `client.rs` | `;Free;` → `;Unlimited;` in UA string |
| **Role header** | ~~Outbound headers~~ | REMOVED - P0 #1 fix | Was `[FREE]` → `[PREMIUM,UNLIMITED]` — **removed for stealth** |
| **Bootstrap premium** | `/v3/bootstrap` | `rest.rs` | Sets `userRole: UNLIMITED`, all feature flags on |
| **Entitlements** | `/v1/entitlements` | `rest.rs` | Sets `rightNow`/`total` to realistic values (3-5) — P1 #15 |
| **Profile premium** | `/v3/me/profile` | `rest.rs` | Injects premium subscription object |
| **User profile** | `/v1/me` | `rest.rs` | Injects premium subscription object (fallback endpoint) |
| **Subscriptions** | `/v4/subscriptions` | `rest.rs` | Injects UNLIMITED tier subscription |
| **Inbox gate removal** | `/v2/inbox`, `/v3/inbox` | `rest.rs` | Removes `upgradeRequired` field |
| **Settings premium** | `/v3/me/settings` | `rest.rs` | Injects premium defaults (`showDistance`, `incognito`) |
| **Prefs premium** | `/v3/me/prefs` | `rest.rs` | Injects `showOnlineStatus`, `showLastSeen` — P2 #14 |
| **Views unlock** | `/v1/views` | `rest.rs` | Removes `truncatedProfiles` paywall — P2 #14 |
| **Favorites unlock** | `/v1/favorites` | `rest.rs` | Removes `maxFavorites` limit — P2 #14 |
| **Album unlock** | `/v4/album`, `/v3/album` | `rest.rs` | Removes `requiresUpgrade` — P2 #14 |
| **Ban bypass** | Any endpoint | `rest.rs` | Intercepts JSON containing `banned`/`suspended`/`restricted` → returns `{\"status\":\"ok\"}` with HTTP 200 |
| **Auto-rotate fingerprint** | Any 401/403 response | `client.rs` | Rotates device fingerprint + UA automatically with rate limiting (300s cooldown, 3 rotation breaker) — P1 #16 |ENDOFFILE

echo "PREMIUM.md updated"
