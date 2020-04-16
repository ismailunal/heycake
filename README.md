[![Build Status](https://drone.smartlogic.io/api/badges/smartlogic/hey_cake/status.svg)](https://drone.smartlogic.io/smartlogic/hey_cake)

# HeyCake

This is an example Phoenix application that uses [Stein](https://github.com/smartlogic/stein) to it's fullest. See how to handle common user functionality with Stein, such as auth, email verification, password resets, uploading, and more.

You can also clone this repo as a starting point for a new project to get going quickly.

## Docker locally

Docker is set up as a replication of production. This generates an erlang release and is not intended for development purposes.

```bash
docker-compose pull
docker-compose build
docker-compose up -d postgres
docker-compose run --rm app eval "HeyCake.ReleaseTasks.Migrate.run()"
docker-compose up app
```

You now can view `http://localhost:4000` and access the application.

## Heroku

Buildpacks required:

- https://github.com/HashNuke/heroku-buildpack-elixir.git
- https://github.com/gjaldon/heroku-buildpack-phoenix-static.git
- https://github.com/oestrich/heroku-buildpack-elixir-mix-release.git

To migrate on heroku:

```bash
heroku run 'hey_cake eval "HeyCake.ReleaseTasks.Migrate.run()"'
```