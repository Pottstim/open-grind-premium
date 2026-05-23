# Random promotion images

[Woodwork](https://www.woodwork.com/) is a service by Grindr.

## Get a random "For You" collection image

Requires [Authorization](/grindr-api/api-authorization).

```
GET /v1/random-images/foryou
```

Query (optional):

- `count` — integer, capped in range [1, 4], optional

Response:

- `images` — array of objects
  - `url` — string
  - `id` — string, e.g. `"WoodworkImage1"`
- `collection` — string, always `foryou`

## RandomPromotionImagesResponse

- `images` — array of objects
  - `url` — string
  - `id` — string, e.g. `"WoodworkImage1"`
- `collection` — string, always `foryou`
