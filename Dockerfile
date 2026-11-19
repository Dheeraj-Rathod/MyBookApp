FROM ruby:3.0.6-slim-bullseye

RUN set -eux; \
    for source in /etc/apt/sources.list /etc/apt/sources.list.d/*; do \
      if [ -f "$source" ]; then \
        sed -i \
          -e 's|deb.debian.org/debian-security|archive.debian.org/debian-security|g' \
          -e 's|deb.debian.org/debian|archive.debian.org/debian|g' \
          "$source"; \
      fi; \
    done; \
    echo 'Acquire::Check-Valid-Until "false";' \
      > /etc/apt/apt.conf.d/99archive; \
    apt-get update -qq; \
    apt-get install -y --no-install-recommends \
      build-essential \
      libpq-dev \
      postgresql-client; \
    rm -rf /var/lib/apt/lists/*

RUN gem install bundler -v 2.5.21

WORKDIR /app

ENV RAILS_LOG_TO_STDOUT=true
ENV RAILS_SERVE_STATIC_FILES=true

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

RUN chmod +x bin/docker-entrypoint

EXPOSE 3000

ENTRYPOINT ["/app/bin/docker-entrypoint"]

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb", "-b", "tcp://0.0.0.0:3000"]