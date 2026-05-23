# Assignments

Assignments are used for feature flagging and A/B testing. They can be assigned to users based on their geohash, allowing for location-based feature rollouts and experiments.

## Get public assignments

```
GET /public/v1/public-features
```

Response:

- `assignments` — array of [Assignment](/grindr-api/analytics/assignments#assignment)

## Get assignments

Requires [Authorization](/grindr-api/api-authorization).

```
GET /v3/assignment
```

Query (optional):

- `geohash` — [Geohash](/grindr-api/browse/location#geohash), optional

Response:

- `assignments` — array of [Assignment](/grindr-api/analytics/assignments#assignment)

## Assignment

- `key` — string, e.g. `"ai-consent-2026"`
- `value` — string, e.g. `"off"` or `"on"` or `"Test"`
- `payload` — arbitrary data object
- `type` — string, e.g. `"FEATURE_FLAG"` or `"EXPERIMENT"`
