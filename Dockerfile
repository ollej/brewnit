FROM ruby:3.4.1

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

# Install fonts
RUN mkdir -p /usr/share/fonts/truetype/
RUN install -m644 /brewnit/app/assets/fonts/*.ttf /usr/share/fonts/truetype/

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
