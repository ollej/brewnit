Brewnit
=======

A site to upload and view beerxml recipes.

Requirements
------------

This application needs the following:

 * Ruby v2.2.3
 * Postgres

Vagrant
-------

Use vagrant and ansible to setup a local development environment
automatically.

### Step 1 - Setup vagrant

#### On Mac with homebrew:

```bash
$ brew install caskroom/cask/brew-cask
$ brew cask install virtualbox
$ brew cask install vagrant
$ brew install ansible
```

#### Other systems

Follow instructions in Vagrant documenation:
https://docs.vagrantup.com/v2/installation/index.html

### Step 2 - Start VM

```bash
$ cd railsbox/development
$ vagrant up
```

### Step 3 - Create config

#### Development mode

Run `bundle exec rake secret` twice and add them to the `config/secrets.yml`
where it says 'changeme' (`secret_key_base` and `devise_pepper`).

For the Google signin support, you need to create credentials on the Google
Developers console and add client_id and client_secret to the
config/secrets.yml

https://console.developers.google.com

#### For production mode

Create a file called `.envrc` in the project root directory with the
environments below.

#### .envrc contents

```
DEVISE_PEPPER=changeme
GOOGLE_CLIENT_ID=
GOOGLE_CLIENT_SECRET=
RACK_ENV=production
RAILS_ENV=production
SECRET_KEY_BASE=changeme
WEB_CONCURRENCY=3
```

### Step 4 - Start application

```bash
$ vagrant ssh
$ sudo start brewnit
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
 * Install Ruby v2.2.3

   ```bash
   $ rbenv install 2.2.3
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

