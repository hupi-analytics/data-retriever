FROM ruby:2.2-alpine as build
RUN apk update && apk add --no-cache nodejs make gcc musl-dev g++ mariadb-dev postgresql-dev mariadb  postgresql 

COPY ./ /app/

WORKDIR /app/

RUN bundle install --path vendor/bundle --without development --standalone --deployment --binstubs vendor/bin/

HEALTHCHECK --interval=20s --timeout=5s --retries=5 CMD nc -z localhost 400 || exit 1
EXPOSE 4000
CMD /app/start.sh
