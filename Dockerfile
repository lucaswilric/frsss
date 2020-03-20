FROM ruby:2.0

WORKDIR /app

CMD ["bundle", "exec", "rackup"]

EXPOSE 9292

COPY . /app/

RUN gem install bundler
RUN bundle install --without test development

