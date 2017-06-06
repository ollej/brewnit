source 'https://rubygems.org'

ruby '2.3.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5'
# Use sqlite3 as the database for Active Record
#gem 'sqlite3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'execjs'
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails', '~> 4.0.5'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
#gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'pg', '~> 0.18.4'
gem 'libxml-xmlrpc', '~> 0.1.5'
gem 'devise', '~> 3.5.3'
gem 'omniauth-google-oauth2', '~> 0.3.1'
gem 'unicorn-rails', '~> 2.2.0'

gem 'nrb-beerxml', git: 'https://github.com/ollej/beerxml.git', ref: '3c3a9c6d7b138a1160e481f276bb2d0923c83911'
gem 'beer_recipe' #, path: './vendor/beer_recipe/'
gem 'commontator', '~> 4.11.0'
gem 'acts_as_votable', '~> 0.10.0'
gem 'search_cop', '~> 1.0.5'
gem 'meta-tags', '~> 2.1.0'
gem 'pushover', '~> 1.0.4'
gem 'paperclip', '~> 4.3.2'
gem 'jquery-ui-rails', '~> 5.0.5'
gem 'fancybox2-rails', '~> 0.2.8'
gem 'chronic', '~> 0.10.2'
gem 'actionview-encoded_mail_to', '~> 1.0.7'

# spam protection
gem 'invisible_captcha', '~> 0.8.0'
gem 'project_honeypot', '~> 0.3.1'
gem 'rack-attack'
gem 'recaptcha', require: 'recaptcha/rails'

# Admin interface
gem 'administrate'

group :production do
  #gem 'rails_12factor', '~> 0.0.3'
end

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'rails_real_favicon'
end

