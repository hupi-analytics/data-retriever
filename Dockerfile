FROM ruby:2.4-alpine as build
RUN apk update && apk add --no-cache nodejs make gcc musl-dev g++ mariadb-dev postgresql-dev mariadb  postgresql 

RUN adduser -D -H -h /app hupi
USER hupi
COPY --chown=hupi ./ /app/
WORKDIR /app/

RUN bundle install --path vendor/bundle --without development --standalone --deployment --binstubs vendor/bin/

FROM ruby:2.2-alpine as run
RUN apk update && apk add --no-cache nodejs mariadb  postgresql  mariadb-dev
RUN adduser -D -H -h /app hupi
USER hupi
COPY --from=build --chown=hupi /app/ /app/
COPY --from=build /usr/local/bundle/config /usr/local/bundle/config
HEALTHCHECK --interval=10s --timeout=5s --retries=30 CMD nc -z localhost 4000 || exit 1

WORKDIR /app/
EXPOSE 4000
CMD /app/start.sh
