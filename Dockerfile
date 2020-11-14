FROM ruby:2.6.5-alpine
LABEL maintainer="georg@ledermann.dev"

# Add basic packages
RUN apk add --update --no-cache \
      postgresql-client \
      tzdata \
      file

# Configure Rails
ENV RAILS_LOG_TO_STDOUT true
ENV RAILS_SERVE_STATIC_FILES true

WORKDIR /app

# Expose Puma port
EXPOSE 3000

# Write GIT commit SHA and TIME to env vars
ONBUILD ARG COMMIT_SHA
ONBUILD ARG COMMIT_TIME

ONBUILD ENV COMMIT_SHA ${COMMIT_SHA}
ONBUILD ENV COMMIT_TIME ${COMMIT_TIME}

# Add user
ONBUILD RUN addgroup -g 1000 -S app && \
            adduser -u 1000 -S app -G app

# Copy app with gems from former build stage
ONBUILD COPY --from=Builder /usr/local/bundle/ /usr/local/bundle/
ONBUILD COPY --from=Builder --chown=app:app /app /app
