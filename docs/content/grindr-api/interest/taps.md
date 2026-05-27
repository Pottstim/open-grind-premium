# Taps

Cookie taps are essentially bubbles "hi" but your client can choose to render them as 🍪. There is no separate cookie tap type.

## Get received taps

Requires [Authorization](/grindr-api/api-authorization).

```
GET /v2/taps/received
```

Response:

- `profiles` — array of [TapProfile](/grindr-api/interest/taps#tapprofile)

## Send a tap

Requires [Authorization](/grindr-api/api-authorization).

```
POST /v2/taps/add
```

Body:

- `recipientId` — [profile id](/grindr-api/users/profiles#profile)
- `tapType` — [Tap ID](/grindr-api/interest/taps#tap-id), invalid or nonexistent Tap IDs are still recorded as successfull

Response:

- `isMutual` — boolean

Errors:

- `400` — Repeated requests result in `Invalid request` error and HTTP status 400.

## Get sent taps

Requires [Authorization](/grindr-api/api-authorization).

```
GET /v1/interactions/taps/sent
```

Response:

Array of objects:
- `senderId` — integer
- `receiverId` — integer
- `tapType` — [Tap ID](/grindr-api/interest/taps#tap-id)
- `sentOn` — unix timestamp in milliseconds
- `deleted` — boolean
- `readOn` — long integer, unknown or `null`

## Tap ID

Tap ID.

- `0` — FRIENDLY ("hi" or 🍪 based on client's rendering settings)
- `1` — HOT (🔥)
- `2` — LOOKING (😈)
- `3` — NONE

## TapProfile

- *everything from [ProfileMaskedMin](/grindr-api/users/profiles#profilemaskedmin)*
- *everything from [ProfileMin](/grindr-api/users/profiles#profilemin)*
- `timestamp` — unix timestamp in milliseconds
- `tapType` — [Tap ID](/grindr-api/interest/taps#tap-id)
- `lastOnline` — unix timestamp in milliseconds
- `isBoosting` — boolean
- `isMutual` — boolean
- `rightNowType` — string
- `isViewable` — boolean
