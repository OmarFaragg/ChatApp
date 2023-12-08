FROM ruby:3.2.2

RUN apt-get update \
	&& apt-get install -y --no-install-recommends default-libmysqlclient-dev nodejs \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app
COPY Gemfile* ./
RUN bundle install
COPY . .

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]