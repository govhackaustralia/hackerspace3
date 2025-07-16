FROM ruby:3.0.0

# Switch package repositories to "archive" because the OS image based on Ruby 3.0.0 is EOL (End Of Life)
# Based on https://unix.stackexchange.com/questions/743839/apt-get-update-failed-to-fetch-debian-amd64-packages-while-building-dockerfile-f
RUN sed -i s/deb.debian.org/archive.debian.org/g /etc/apt/sources.list && \
    sed -i s/security.debian.org/archive.debian.org/g /etc/apt/sources.list && \
    sed -i s/stretch-updates/stretch/g /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends postgresql-client && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app
COPY Gemfile* ./
RUN bundle install
COPY . .

EXPOSE 3000
COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT [ "docker-entrypoint.sh" ]
CMD ["rails", "server", "-b", "0.0.0.0"]
