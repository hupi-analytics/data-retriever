FROM ruby:2.2-alpine as build
RUN apk update && apk add nodejs make gcc musl-dev g++ mariadb-dev postgresql-dev mariadb  postgresql 

COPY ./ /app/

WORKDIR /app/

RUN bundle install --path vendor/bundle --without development --standalone --deployment --binstubs vendor/bin/

EXPOSE 4000
CMD /app/start.sh
