FROM ruby:2.2.4

RUN apt-get update && apt-get install -y nodejs

COPY ./ /app/

WORKDIR /app/

RUN gem install bundler
RUN bundle install --path vendor/bundle --without development --standalone --deployment --binstubs vendor/bin/



EXPOSE 4000
CMD /app/start.sh
