# Spotify, WIP

> [!NOTE] This page is a work in progress. Endpoints below haven't been fully researched.

## Spotify token, WIP

```
POST /api/token
```

Body:

Content-Type: `application/x-www-form-urlencoded`

Map of string to string.

## Get spotify favorites, WIP

```
GET /v4/spotify/favorites/{profileId}
```

## Post spotify favorites, WIP

```
POST /v4/spotify/favorites
```

## Search spotify tracks, WIP

```
GET /v1/search
```

Query (optional):

- `q` — string, optional
- `type` — string, optional

## Get spotify tracks, WIP

```
GET /v1/tracks
```

Query (optional):

- `ids` — string, optional

## Get spotify recently played, WIP

```
GET /v1/me/player/recently-played
```
