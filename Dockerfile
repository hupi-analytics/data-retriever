FROM ruby:2.2.4

RUN echo "deb [trusted=yes] http://archive.debian.org/debian-archive/debian/ jessie main contrib non-free" > /etc/apt/sources.list
RUN apt-get update && apt-get install -y nodejs

COPY ./ /app/

WORKDIR /app/

RUN gem install bundler  -v '~> 1.12.5'
RUN bundle install --path vendor/bundle --without development --standalone --deployment --binstubs vendor/bin/



EXPOSE 4000
CMD /app/start.sh
