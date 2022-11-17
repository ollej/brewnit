Brewnit
=======

A site to upload, view, and edit beerxml recipes.

Related resources
-----------------

### Recipe sites

 * http://olrecept.se
 * http://malt.io
 * http://beercalc.org
 * http://beerrecipes.org
 * http://brewgr.com
 * http://brewtoad.com
 * http://brewersfriend.com

### Recipe applications

 * [Beersmith](http://beersmith.com/)
 * [QBrew](http://freecode.com/projects/qbrew)
 * [Brewtarget](http://www.brewtarget.org/)
 * [Brew Pal (iOS)](http://www.djpsoftware.com/brewpal/)
 * [BrewR (Android)](https://play.google.com/store/apps/details?id=com.weekendcoders.brewr&hl=en)
 * [Wort (Android)](https://play.google.com/store/apps/details?id=info.dynamicdesigns.wort&hl=en)
 * [Brewer's Friend (iOS, Android)](https://www.brewersfriend.com/)
 * [Brewfather](https://brewfather.app)

Requirements
------------

This application needs the following:

 * Ruby v3.0.2
 * Postgres v9.6
 * Docker for development environment

Docker
------

Use docker to setup a local development environment.

### Step 1 - Build

```
docker-compose build
```

### Step 2 - Start

```
docker-compose up
```

### Step 3 - Create database

```
docker-compose run web rake db:create
```

### Step 4 - Run database migrations

```
docker-compose run web rake db:migrate
```

### Step 5 - Create config

Add the following to a file called `.env.development`.

```
DEVISE_PEPPER: changeme
GOOGLE_CLIENT_ID: changeme
GOOGLE_CLIENT_SECRET: changeme
SECRET_KEY_BASE: changeme
WEB_CONCURRENCY: 3
PUSHOVER_USER: changeme
PUSHOVER_TOKEN: changeme
PUSHOVER_GROUP_RECIPE: changeme
PROJECT_HONEYPOT_KEY: changeme
SMTP_PASSWORD: changeme
RECAPTCHA_SITE_KEY: changeme
RECAPTCHA_SECRET_KEY: changeme
INKSCAPE_PATH: /usr/bin/inkscape
INKSCAPE_VERSION=1
DEVELOPMENT_HOST: yourcomputer.local
SLACK_SIGNING_SECRET: changeme
```

#### Development mode

Run `bundle exec rake secret` twice and add them to the `.env.development`
where it says 'changeme' (`SECRET_KEY_BASE` and `DEVISE_PEPPER`).

##### Google authentication

For the Google signin support, you need to create credentials on the Google
Developers console and add `client_id` and `client_secret` to the
`.env.development`

https://console.developers.google.com

##### reCAPTCHA

The reCAPTCHA supports needs a `site_key` and `secret_key`:
https://www.google.com/recaptcha/admin

##### Pushover

The Pushover integration needs keys from https://pushover.net/

##### Project Honeypot

Project Honeypot is used for spam protection. A key can be obtained from:
https://www.projecthoneypot.org/

##### SMTP password

For mailers to work, an SMTP password needs to be configured in
`smtp_password`.

The SMTP server and user_name is hardcoded in `config/application.rb`

##### Inkscape

If you have inkscape installed, you can set `INKSCAPE_PATH` to use inkscape
to generate beer labels when creating the beer label pdf.

#### For production mode

Create a file called `.envrc` in the project root directory with the
environments below.

#### .envrc contents

```
DEVISE_PEPPER=changeme
GOOGLE_CLIENT_ID=changeme
GOOGLE_CLIENT_SECRET=changeme
RACK_ENV=production
RAILS_ENV=production
SECRET_KEY_BASE=changeme
WEB_CONCURRENCY=3
PUSHOVER_USER=changeme
PUSHOVER_TOKEN=changeme
PUSHOVER_GROUP_RECIPE=changeme
PROJECT_HONEYPOT_KEY=changeme
SMTP_PASSWORD=changeme
RECAPTCHA_SITE_KEY=changeme
RECAPTCHA_SECRET_KEY=changeme
SPAM_IP=space separated list of IP addresses to block
INKSCAPE_PATH=/usr/bin/inkscape
SLACK_SIGNING_SECRET=changeme
SPAM_COUNTRIES=space separated list of countries to block registrations from
```

Manual installation
-------------------

### Ruby installation

If you don't have Ruby, here is a short primer:

 * Install rbenv: https://github.com/rbenv/rbenv#basic-github-checkout
 * Install ruby-build rbenv plugin:

   ```bash
   $ git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
   ```
 * Install Ruby

   ```bash
   $ rbenv install 3.0.2
   ```
 * Install bundler

   ```bash
   $ gem install bundler
   ```

### Application

Basically just clone the Github repository and run `bundle install`.

```bash
$ git clone https://github.com/ollej/brewnit.git brewnit
$ cd brewnit
$ bundle install
$ createdb brewnit_dev
$ bundle exec rake db:migrate
```

Run `bundle exec rake secret` twice and add them to the `config/secrets.yml`
where it says 'changeme' (secret_key_base and devise_pepper).

For the Google signin support, you need to create credentials on the Google
Developers console and add client_id and client_secret to the
config/secrets.yml

https://console.developers.google.com

### Start server

Start the web server with the following command.

```bash
$ bundle exec rails s
```

### Useful commands

#### Regenerate favicon files

```
rails generate favicon
```

Attributions
------------

 * Loading spinner from: https://preloaders.net
 * Flat icons from: https://flaticon.com
 * Sounds from: https://www.soundjay.com
 * Sounds from: https://www.freesound.org

How to Contribute?
------------------

It's easy, just follow the [contribution guidelines][contribution].

[contribution]: https://github.com/ollej/brewnit/blob/master/CONTRIBUTING.md
