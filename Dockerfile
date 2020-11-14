FROM ruby:2.6.5-stretch
LABEL maintainer="saiyedfaishal@gmail.com"

# Add basic packages
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  libpq-dev \
  file \
  postgresql-client \
  tzdata \
  yarn


# Configure Rails
ENV RAILS_LOG_TO_STDOUT true
ENV RAILS_SERVE_STATIC_FILES true

WORKDIR /app

# Expose Puma port
EXPOSE 3000

# This image is for production env only
ENV RAILS_ENV production

# Write GIT commit SHA and TIME to env vars
ONBUILD ARG COMMIT_SHA
ONBUILD ARG COMMIT_TIME

ONBUILD ENV COMMIT_SHA ${COMMIT_SHA}
ONBUILD ENV COMMIT_TIME ${COMMIT_TIME}

# Add user
ONBUILD RUN addgroup --gid 1000 app
ONBUILD RUN adduser --disabled-password --gecos '' --uid 1000 --gid 1000 app

# Copy app with gems from former build stage
ONBUILD COPY --from=Builder --chown=app:app /usr/local/bundle/ /usr/local/bundle/
ONBUILD COPY --from=Builder --chown=app:app /app /app
