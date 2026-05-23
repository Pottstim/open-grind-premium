# Social events

## Get social events

Requires [Authorization](/grindr-api/api-authorization).

```
GET /v1/social-events
```

Query (optional):

- `geohash` — string, optional
- `sort` — string, optional
- `region` — string, optional

Response:

- `events` — array of [SocialEvent](/grindr-api/browse/social-events#socialevent)

## SocialEvent

- `socialEventId` — long integer
- `name` — string
- `location` — string
- `startTime` — unix timestamp in milliseconds
- `endTime` — unix timestamp in milliseconds
- `eventType` — string, e.g. `FESTIVAL` | `KINK` | `PRIDE`
- `eventImageUrl` — URL
- `imageSource` — string
- `region` — string
- `attendeesPreview` — array of objects
  - `profileId` — long integer
  - `profileImageUrl` — string, may be empty
- `timezone` — string
- `isAttending` — boolean
