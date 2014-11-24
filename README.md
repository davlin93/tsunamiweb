It's Tsunami, motherfuckers.

# API

## User Endpoint

### GET /api/users

returns all users

### POST /api/users

```
{
  "guid": "f9852ca7-75e0-4e00-8229-125232ba14f8"
}
```
creates user and returns
```
{
  ... user info ...
}
```

## Ripple Endpoint

### GET /api/ripple

returns all ripples

### POST /api/ripple

```
{
  "latitude": 50,
  "longitude": 50,
  "wave_id": 1,
  "guid": "f9852ca7-75e0-4e00-8229-125232ba14f8"
}
```
creates a ripple for wave 1 and returns
```
{
  "id": 1,
  "latitude": 50,
  "longitude": 50,
  "radius": 0.025,
  "user": {
    ... user info ...
  },
  "wave": {
    ... wave info ...
  }
}
```

## Ocean Endpoint

### GET /api/ocean/all_waves

returns all waves (content, no location)

### GET /api/ocean/local_waves?latitude=50&longitude=50&guid=1

returns all waves that have active ripples within radius
```
[
  {
    "id": 1,
    "origin_ripple_id": 1,
    "content": "waaaave",
    "ripples": [
      {
        ... ripple info ...
      },

      ...
    ],
    "user": {
      ... user info ...
    }
  },

  ...
]
```

### POST /api/ocean/splash

```
{
  "latitude": 123.4567,
  "longitude": 123.4567,
  "content": "wave content",
  "guid": "f9852ca7-75e0-4e00-8229-125232ba14f8"
}
```
creates new wave and ripple, sets ripple as origin ripple for wave, then returns
```
{
  "id": 1,
  "origin_ripple_id": 1,
  "content": "wave content",
  "ripples": [
    {
      "id": 1,
      "latitude": 123.4567,
      "longitude": 123.4567,
      "radius": 0.025
    }
  ],
  "user": {
    "id": 1,
    "guid": "f9852ca7-75e0-4e00-8229-125232ba14f8"
  }
}
```
