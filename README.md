Brewnit
=======

A site to upload and view beerxml recipes.

Requirements
------------

This application needs the following:

 * Ruby v2.2.3
 * Postgres

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

Install
-------

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


Usage
-----

Start the web server with the following command.

```bash
$ bundle exec rails s
```
