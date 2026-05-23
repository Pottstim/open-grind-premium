# Favorites

## Add favorite

Requires [Authorization](/grindr-api/api-authorization).

```
POST /v3/me/favorites/{profileId}
```

Response:

Empty object (`{}`).

## Remove favorite

Requires [Authorization](/grindr-api/api-authorization).

```
DELETE /v3/me/favorites/{profileId}
```

Response:

Empty object (`{}`).

## Get all notes

Requires [Authorization](/grindr-api/api-authorization).

```
GET /v1/favorites/notes
```

Response:

Array of [FavoriteNoteWithCounterparty](/grindr-api/users/favorites#favoritenotewithcounterparty).

## Get note

Requires [Authorization](/grindr-api/api-authorization).

```
GET /v1/favorites/notes/{targetProfileId}
```

Response:

- `notes` — string, empty for nonexistent notes
- `phoneNumber` — string, might be empty

## Add note

Requires [Authorization](/grindr-api/api-authorization).

The `counterpartyId` parameter seems to be ignored, it's unknown what its purpose is.

```
PUT /v1/favorites/notes/{targetProfileId}
```

Body:

- `notes` — string, empty for nonexistent notes
- `phoneNumber` — string, might be empty

Response:

Empty, HTTP status 204.

## Delete note

Requires [Authorization](/grindr-api/api-authorization).

Essentially equivalent to [Add note](/grindr-api/users/favorites#add-note) with `notes` set to `""`.

```
DELETE /v1/favorites/notes/{targetProfileId}
```

## FavoriteNote

- `notes` — string, empty for nonexistent notes
- `phoneNumber` — string, might be empty

## FavoriteNoteWithCounterparty

- *everything from [FavoriteNote](/grindr-api/users/favorites#favoritenote)*
- `counterpartyId` — long integer, profile ID
