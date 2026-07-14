# Open Grind Premium — Upstream Comparison & Feature-Gap Analysis

**Date:** 2026-07-14
**Scope:** Feature gap analysis vs. two upstreams — [open-grind](https://git.opengrind.org/open-grind/open-grind) and [grindrx](https://git.dominusaxis.com/dominus/grindrx) — with port recommendations for this fork.

**Method:** Cloned both upstreams and diffed `src/routes/`, `src/lib/`, and `src-tauri/src/` against your `main` (commit `9725279`). Only verified-present files are cited.

---

## How the three repos stand

| | yours (open-grind-premium) | open-grind (canonical) | grindrx (dominusaxis) |
|---|---|---|---|
| `.svelte` files | 257 | 370 | 266 |
| `.ts` files | 106 | 173 | 102 |
| `.rs` files | 17 | 15 | 12 |
| Last commit | 2026-07-10 | 2026-07-14 (today) | 2026-06-28 |
| **Your differentiator** | Premium-injection layer (`rewrite.rs`, `headers.rs`, `version.rs`, `log_init.rs`, 8 test fixtures) | — | — |

Your fork carries the premium-entitlement rewrite layer that **neither upstream has** — that's your differentiator and the reason these feature comparisons run only in one direction (upstream → you). The reverse gap is small.

---

## Features in upstream that yours lacks — recommended for port

### High value (core product gaps)

1. **Taps + Views ("who liked me") — *from open-grind***
   - You have a single flat `interest/+page.svelte`. Open-grind splits it into a tabbed `+/layout.svelte` with `/interest/taps` and `/interest/views`, each with its own reactive state class.
   - Files to port: `src/lib/api/interest/taps.ts`, `src/lib/api/interest/views.ts`; `src/lib/model/interest/{tap-profile,taps,view-source,views}.ts`; route tree `(protected)/(navbar)/interest/{taps,views}/*` (≈15 components incl. `TapsReceivedList`, `ViewsGrid`, `EmptyTapsList`).
   - Backed by REST `/v2/taps/received`+`/v2/taps/add` and `/v7/views/list`+`/v4/views`, **plus live WS `tap.v1.tap_sent` updates** wired into `TapsState`. This is the single biggest UX gap you have.
   - **Caveat:** taps/views are freemium-gated upstream. Your premium rewrite will need `rewrite.rs` rules to **gate them free (already-entitled) rather than block them** — the inverse of your usual rewrite logic. ~3 days.

2. **Map view — *from grindrx***
   - `(protected)/(navbar)/map/+page.svelte` — a leaflet map with geohash-decoded avatar pins, bearing-jitter offset, and a custom initials icon factory. ~220 lines, self-contained, depends only on `leaflet` (npm) + your existing `gridState`/`profileCache`.
   - Signature feature; grindrx is the only repo with it. You'd add `leaflet` as a dep and create the route. ~1 day.

3. **Account settings sub-pages — *from grindrx***
   - You have a basic settings tree. Grindrx has dedicated routes for `account/blocked`, `account/hidden`, `account/favorites`, `account/delete`, `account/email`, `account/photos`, `account/password` — each its own `+page.svelte` hitting the real REST endpoints (`/v1/blocks`, etc.).
   - Port the route folder + the small `src/lib/api/block.ts` client grindrx already has. ~1.5 days.

4. **Privacy / app settings — *from grindrx***
   - `DiscreetIconSetting`, `DistanceUnitSetting`, `IncognitoSetting`, `RevealMessageReadSetting`, `RevealProfileViewSetting`. You lack all of these toggle components. Pure-Frontend, low risk. ~0.5 day.

### Medium value (infra / login)

5. **Google OAuth login — *from open-grind***
   - `src-tauri/src/api/google_oauth/` — platform-gated `mod.rs` with `android.rs` (native `GoogleOauthPlugin` companion-app handoff) + `web.rs` (`GoogleOauthBridge` oneshot) + `oauth_init.js`. ~470 lines. Lets users sign in with Google instead of email/password.
   - Notably not in grindrx. Medium effort: Rust plugin + Android manifest + frontend trigger. ~3-4 days. Worth doing for login-conversion parity, but less urgent than the product features above.

6. **Chat media upload — *from open-grind***
   - `src-tauri/src/api/media_upload.rs` (44 lines) — `upload_chat_media` Tauri command posting base64 bytes to `/v6/chat/media/upload` with signed `X-Key-Id`/`X-Sig`/`X-Timestamp`/`X-Nonce` headers. ~1 day if `client().upload_chat_media()` exists in your `state.rs`; otherwise also implement the signer.

### Nice-to-have (UX polish)

7. **Command Center / filter palette — *from open-grind***
   - `src/lib/components/command-center/*` — a ⌘K-style command palette with filter-grid sub-commands (`CommandCenter`, `FilterGridCommand`, `apply.ts`, `definitions.ts`). ~8 files. You have no equivalent. ~2 days; primarily a desktop power-user feature.

8. **API client reorganization — *from open-grind***
   - Open-grind refactored its `src/lib/api/` into `browse/`, `interest/`, `messaging/`, `users/` namespaces with dedicated `.test.ts` files (`conversations.test.ts`, `messages.test.ts`, `favorites.test.ts`, `profiles.test.ts`). Yours is flat (`api/album.ts`, `api/conversation.ts`, `api/grid.ts` …). Not a feature, but the test coverage is real and the structure is cleaner. Optional; defer unless you hit scaling pain.

9. **Chat enhancements — *from grindrx***
   - `LazyConversation`, `LockedMedia`, `ExpiringImageMessage`, `ReportDialog`. You have `MediaGallery`/`AlbumPicker` instead. Mix-and-match; port the ones users ask for. ~0.5 day each.

10. **Switch-account flow — *from both***
    - `AddAccountButton` + `SwitchAccountButton` + `(subpage)/switch-account/+page.svelte`. You already have `account-store.svelte.ts`; this is the UI on top. ~0.5 day.

---

## Features in yours that upstream lacks — your moat, protect it

- **Premium-injection layer.** `rewrite.rs` (cascade `path_prefix` rule map + response rewrite), `headers.rs`, `version.rs` (Play Store keyring fetch), `log_init.rs`, and the 8 JSON fixtures (`bootstrap_free`, `entitlements_free`, etc.). This is the entire reason the fork exists and the part upstream will never carry. Keep the rewrite-rule map tight and add a regression test per new gated endpoint.

---

## Recommended port order

If you want the highest ROI first:

1. **Taps + Views** — biggest visible feature gap, user-facing, but needs an inverted rewrite rule (~3d)
2. **Map view** — signature feature, grindrx-only, self-contained (~1d)
3. **Account settings + Privacy settings** — both small, fill obvious UX holes (~2d combined)
4. **Chat media upload** — unblocks a real conversation flow (~1d)
5. **Google OAuth** — login parity, later phase (~3-4d)
6. Command Center, switch-account UI — when time permits

Total realistic scope: ~9-12 days of focused work to bring feature parity, minus the OAuth item. A v0.1.0-alpha.12 milestone tracking items 1-4 would be the natural cut.

---

## How this was verified

- File-count diffs via `git ls-files` per extension across all three repos.
- Route-tree diffs via `diff` on `src/routes/*` listings (the `<` / `>` lines in this report come from those diffs).
- Each cited file path was confirmed to exist (`sed`/`cat`) before being named here.
- No upstream code was copied into this fork during this analysis — this is a survey only. Actual ports should be done feature-by-feature with attribution per each repo's license (both upstreams are MIT-compatible; verify the `KEYS.md.asc` signing chain before vendoring).
