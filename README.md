# GovHack - Hackerspace

A system to manage competition participants, sponsors, and management.

## Getting Started

### Installing Docker

The easiest way to get started is to install Docker. Docker uses a concept called containers, which allows you to get started on software without having to manually setup your development environment and install a bunch of things - Docker will handle that for you.

#### Instructions for Windows

Installing Docker on Windows is a bit tricky so we have additional inforamation:

If running Windows 10 Pro, Enterprise, or Education, use these instructions - https://docs.docker.com/docker-for-windows/install/

If running Windows 10 Home, use these instructions - https://docs.docker.com/docker-for-windows/install-windows-home/

**Issues that you may encounter:**
* Unable to install WSL 2 due to running an older version of Windows
  * **Solution** is to install WSL 1 and then install an older version of Docker. Try installing [2.1.0.5](https://docs.docker.com/docker-for-windows/release-notes/#docker-desktop-community-2101)
* Unable to install Docker with Error: Installation Failed: one prerequisite is not fulfilled. Docker Desktop requires Windows 10 Pro or Enterprise version xxxxx to run.
  * **Solution** is to follow [this workaround](https://itnext.io/install-docker-on-windows-10-home-d8e621997c1d) to 'trick' Docker during installation

Once installed and running, use Powershell to follow the instructions in the **Docker Deployment Instructions** section.

## Framework

Hackerspace 3 is a [Ruby on Rails application](https://rubyonrails.org/)

Current major version is 6

Check out the [Rails Guides](https://guides.rubyonrails.org/index.html) to get up and running.

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

If you don't want to wait for the Docker image to build from your local copy of the repo, start with:

```bash
docker pull govhackau/hackerspace3
```

(If you don't do the above, the image will get automatically built; this should take about 10 minutes on a modern machine.)

Run Hackerspace:

**NOTE**: The initial run of Hackerspace will likely take several minutes to initialise the database before being usable. This is normal.

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

**NOTE:** If you do this, you'll need to re-run the "Initialise the postgres database" instructions above, the next time you want to use Hackerspace. Only do this if you want to start with a fresh database, or completely remove the Hackerspace project from Docker.

```bash
$ docker-compose down -v
```

To explicitly rebuild a new `hackerspace3` Docker image from your local code:

```bash
docker build -t govhackau/hackerspace3 .
```

Or, to build the image *and* start the container as usual, run:

```bash
docker-compose up --build
```

To actively make local changes to your codebase without needing to rebuild the image, start the database image with:

```bash
docker-compose up -d postgres
```

Then start the `govhackau/hackerspace3` image with:

```bash
docker-compose run --rm -d -v "$(pwd)":/usr/src/app --service-ports hackerspace3
```

NOTE: Due to the "$(pwd)" in the above command, it should work in any POSIX shell (bash/sh/zsh etc), and PowerShell. It won't work in Windows Command Prompt.

This runs the container and bind-mounts your checked out code into the container so you can work on it without needing to rebuild the container's image.

## Specification Documents

All documents relating to specification can be found in the [project
wiki](https://github.com/govhackaustralia/hackerspace3/wiki).

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
