Brewnit
=======

A site to upload and view beerxml recipes.

Requirements
------------

This application needs the following:

 * Ruby v2.2.3

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
```

Usage
-----

Start the web server with the following command.

```bash
$ bundle exec rails s
```
