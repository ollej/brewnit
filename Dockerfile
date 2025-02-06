FROM ruby:3.3.7

RUN apt-get update -qq && \
    apt-get install -qy nodejs postgresql-client inkscape && \
    rm -rf /var/lib/apt/lists/*

# Configure bundler
ENV LANG=C.UTF-8 \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3

# Upgrade RubyGems and install required Bundler version
RUN gem update --system && \
    gem install bundler

RUN mkdir -p /brewnit
WORKDIR /brewnit
COPY Gemfile /brewnit/Gemfile
COPY Gemfile.lock /brewnit/Gemfile.lock
RUN bundle install
COPY . /brewnit

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
