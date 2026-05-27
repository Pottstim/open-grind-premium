# Travels

## Get travel plans

Requires [Authorization](/grindr-api/api-authorization).

```
GET /v6/profiles/travel/{profileId}
```

Response:

- `travelPlans` — array of [TravelPlanMutation](/grindr-api/browse/travels#travelplanmutation)

## Create travel plans

Requires [Authorization](/grindr-api/api-authorization).

```
POST /v6/profiles/travel
```

Body:

- `travelPlanId` — long integer, required for update, ignored for create
- `profileId` — long integer
- `geohash` — [Geohash](/grindr-api/browse/location#geohash)
- `startDate` — unix timestamp in milliseconds
- `endDate` — unix timestamp in milliseconds
- `showOnProfile` — boolean
- `notes` — string

Response:

Empty.

## Update travel plans

Requires [Authorization](/grindr-api/api-authorization).

```
POST /v6/profiles/travel/update
```

Body:

- `travelPlanId` — long integer, required for update, ignored for create
- `profileId` — long integer
- `geohash` — [Geohash](/grindr-api/browse/location#geohash)
- `startDate` — unix timestamp in milliseconds
- `endDate` — unix timestamp in milliseconds
- `showOnProfile` — boolean
- `notes` — string

Response:

Empty.

## Delete travel plans

Requires [Authorization](/grindr-api/api-authorization).

Repeated requests are completed without errors.

```
DELETE /v6/profiles/travel/{travelPlanId}
```

Response:

Empty.

## TravelPlanMutation

- `travelPlanId` — long integer, required for update, ignored for create
- `profileId` — long integer
- `geohash` — [Geohash](/grindr-api/browse/location#geohash)
- `startDate` — unix timestamp in milliseconds
- `endDate` — unix timestamp in milliseconds
- `showOnProfile` — boolean
- `notes` — string
