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

### GET /api/users/1

returns data for user with id 1

```
{
  "id": 1,
  "created_at": "2014-12-26T05:23:56Z",
  "updated_at": "2014-12-26T05:23:56Z",
  "viewed": 4,
  "ripples": 3,
  "ripple_chance": 0.50,
  "splashes": 2,
  "views_across_waves": 94,
  "ripples_across_waves": 3
}
```

### PUT /api/users/1

```
{
  "social_profiles":
  {
    "twitter": "my_handle",
    "facebook": "my_facebook"
  }
}
```

updates (or creates) given fields and returns new user

```
{
  "id": 1,
  "created_at": "2014-12-26T05:23:56Z",
  "updated_at": "2014-12-26T05:23:56Z",
  "social_profiles":
  [
    {
      "username": "my_handle",
      "service": "twitter",
      "id": 1,
      "created_at": "2014-12-26T05:23:56Z",
      "updated_at": "2014-12-26T05:23:56Z"
    },
    {
      "username": "my_facebook",
      "service": "facebook",
      "id": 1,
      "created_at": "2014-12-26T05:23:56Z",
      "updated_at": "2014-12-26T05:23:56Z"
    }
  ],
  "viewed": 4,
  "ripples": 3,
  "ripple_chance": 0.50,
  "splashes": 2,
  "views_across_waves": 94,
  "ripples_across_waves": 3
}
```

### GET /api/users/waves?user_id=7890

Returns the list of waves the user splashed

### POST /api/users

```
{ 
  "guid": "12345678"
}
```
If a user with guid already exists, an error will be thrown.
Otherwise, creates user and returns
```
{
  "id": 1,
  "guid": "12345678",
  "created_at": "2014-12-26T05:23:56Z",
  "updated_at": "2014-12-26T05:23:56Z",
  "viewed": 0
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
  "user_id": 1
}
```
* creates a ripple for wave 1
* adds ripple to user associated with user_id
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

### GET /api/ocean/local_waves?latitude=50&longitude=50&user_id=1

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
  "user_id": 1
}
```
* creates new wave and ripple
* sets ripple as origin ripple for wave
* adds new wave and ripple to user associated with user_id
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
    "id": 1
  }
}
```

### POST /api/ocean/dismiss

request:
```
{
  "user_id": 1,
  "wave_id": 1
}
```

Increments wave views and user viewed count, then returns OK

## Comments Endpoint
### POST /api/comments
request:
```
{
  "user_id": 1,
  "wave_id": 1,
  "body": "comment"
}
```
creates a comment on wave 1 from user with id 1, then returns 201
