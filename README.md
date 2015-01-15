It's Tsunami, motherfuckers.

# Heroku setup

### Toolbelt setup
* https://toolbelt.heroku.com/

### Executing commands
`heroku run -a tsunami-mobile`
* reset db:reset
 * resets db
 * runs drop, create, schema:load

`heroku logs -a tsunami-mobile`
 * append --tail to tail

# API Docs

## User Endpoint

### GET /api/users

returns all users

### GET /api/users/stats?guid=7890

```
{
  "viewed": 4,
  "ripples": 3,
  "ripple_chance": 0.50,
  "splashes": 2,
  "views_across_waves": 94,
  "ripples_across_waves": 3
}
```

### GET /api/users/waves?guid=7890

Returns the list of waves the user splashed

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
* creates a ripple for wave 1
* adds ripple to user associated with guid, if no user exists, creates one
then returns:
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
    "created_at": "2014-12-26T05:23:56Z",
    "updated_at": "2014-12-26T05:23:56Z",
    "origin_ripple_id": 1,
    "content": {
      "title": "wave title",
      "body": "wave body"
    },
    "views": 100,
    "ripples": [
      {
        ... ripple info ...
      },

      ...
    ],
    "user": {
      ... user info ...
    },
    "comments": [
      {
        "user_id": 1,
        "wave_id": 1,
        "body": "comment body",
        "created_at": "2014-12-26T05:23:56Z",
        "updated_at": "2014-12-26T05:23:56Z"
      }
    ]
  },

  ...
]
```

### POST /api/ocean/splash

```
{
  "latitude": 123.4567,
  "longitude": 123.4567,
  "title": "wave title",
  "body": "wave body",
  "guid": "f9852ca7-75e0-4e00-8229-125232ba14f8"
}
```
* creates new wave and ripple
* sets ripple as origin ripple for wave
* adds new wave and ripple to user associated with guid, creates one if none exist
then returns
```
{
  "id": 1,
  "origin_ripple_id": 1,
  "content": {
    "title": "wave title",
    "body": "wave body"
  },
  "views": 100,
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

### POST /api/ocean/dismiss

request:
```
{
  "guid": "12345",
  "wave_id": 1
}
```

Increments wave views and user viewed count, then returns OK

## Comments Endpoint
### POST /api/comments
request:
```
{
  "guid": "12345",
  "wave_id": 1,
  "body": "comment"
}
```
creates a comment on wave 1 from user with guid 12345, then returns 201
