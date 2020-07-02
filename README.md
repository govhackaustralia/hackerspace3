# GovHack - Hackerspace

A system to manage competition participants, sponsors, and management.

## Framework

Hackerspace 3 is a [Ruby on Rails application](https://rubyonrails.org/)

Current major framework version is 6

## Ruby version

- `2.6.3`

## Database initialization and creation

[PostgreSQL](https://www.postgresql.org/) is required.

```bash
$ rails db:setup
```

*This will load the seeds also, see db/seeds.rb for more options*

## Test Suite

Current coverage is unit tests for models, controllers, and services.

```bash
$ rails test
```

## Services

hackerspace3 makes use of AWS and Google services.

See the below Environment Variables Required to enable specific services.

## Deployment instructions

```bash
$ rails server
```

## Docker Deployment Instructions

Initialise environment variables required by `docker-compose`:

```bash
cp .env.example .env
```

**IMPORTANT**: Then edit `.env` with a text editor and choose a more secure password for the `POSTGRES_PASSWORD` variable.

Initialise the postgres database:

```bash
$ docker-compose up -d postgres
$ docker-compose run --rm hackerspace3 rails db:setup
$ docker-compose down
```

Run Hackerspace:

```bash
$ docker-compose up -d
```

Then browse to http://localhost:3000 and click Sign In.

* Username: `admin@hackerspace.com`
* Password: `password`

(Note, refer to `db/seeders/seeder.rb` and `db/seeders/user_seeder.rb` to see where these are set)

To stop Hackerspace:

```bash
$ docker-compose down
```

Or, to stop and remove the Hackerspace database:

```bash
$ docker-compose down -v
```

## Specification Documents

All documents relating to specification can be found in the [project
wiki](https://github.com/cassar/hackerspace3/wiki).

## Environment Variables Required

Set these in `config/application.yml` using [figaro](https://github.com/laserlemon/figaro)

### Seed File

Optional: Set if running in development and running the seed file.

- SEED_EMAIL (defaults to: admin@hackerspace.com)
- SEED_NAME (defaults to: Admin User)

### Web Deployment

Set if running in staging or production environments.

- DOMAIN
- SECRET_KEY_BASE

### Google Authentication

- GOOGLE_CLIENT_ID
- GOOGLE_CLIENT_SECRET

### AWS Simple Email Service

- AWS_SES_ID
- AWS_SES_KEY
- AWS_SES_SERVER
- DEFAULT_FROM_EMAIL
- FINANCE_EMAIL

### AWS S3

- AWS_ACCESS_ID
- AWS_ACCESS_KEY
- AWS_S3_REGION
- AWS_S3_BUCKET

### Google Maps API

- GOOGLE_API_KEY
