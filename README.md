It's Tsunami, motherfuckers.

# API

## User Endpoint

### GET /api/users

returns all users

### POST /api/users

```
{
  "name": "David"
}
```
creates user and returns
```
{
  ... user info ...
}
```

## Splash Endpoint

### GET /api/splash

returns all splashes

### POST /api/splash

```
{
  "latitude": 50,
  "longitude": 50,
  "content": "waaaave",
  "user_id": 1
}
```
creates new wave and splash, links them, then returns
```
{
  "wave": {
    ... wave info ...
  },
  "splash": {
    ... splash info ...
  },
  "user": {
    ... user info ...
  }
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
  "user_id": 2
}
```
creates a ripple for wave 1 and returns
```
{
  ... ripple info ...
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

### GET /api/ocean/local_waves&latitude=50&longitude=50&user_id=1

returns all waves that have splashes or ripples within radius
```
[
  {
    (wave)
    "id": 1,
    "content": "waaaave",
    "splash": {
      ... splash info ...
    },
    "ripples": {
      ... ripple info ...
    }
  },

  ...
]
```
