source 'https://rubygems.org'

ruby '2.4.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.8'
# Use sqlite3 as the database for Active Record
#gem 'sqlite3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'execjs'
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
#gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'pg'
gem 'libxml-xmlrpc', '~> 0.1.5'
gem 'devise'
gem 'omniauth-google-oauth2', '~> 0.3.1'
gem 'unicorn-rails', '~> 2.2.0'

gem 'nrb-beerxml', git: 'https://github.com/ollej/beerxml.git', ref: '3c3a9c6d7b138a1160e481f276bb2d0923c83911'
gem 'beer_recipe' #, path: './vendor/beer_recipe/'
gem 'commontator', '~> 4.11.0'
gem 'acts_as_votable'
gem 'search_cop', git: 'https://github.com/mrkamel/search_cop.git', ref: '1082a2f7862321cf8f1c4560a2b6602a0c256e59'
gem 'meta-tags', '~> 2.1.0'
gem 'pushover', git: 'https://github.com/vito-lbs/pushover.git', ref: '3bbb7ea026b3d30c043ba033d596dab6fec2a031'
gem 'paperclip', '~> 4.3.2'
gem 'fancybox2-rails', '~> 0.2.8'
gem 'chronic', '~> 0.10.2'
gem 'actionview-encoded_mail_to', '~> 1.0.7'
gem 'quilljs-rails'
gem 'csv_shaper', '~> 1.3.0'
gem 'axlsx'
gem 'axlsx_rails'
gem 'dotenv-rails'

# spam protection
gem 'invisible_captcha'
gem 'project_honeypot', '~> 0.3.1'
gem 'rack-attack'
gem 'recaptcha', require: 'recaptcha/rails'

# Admin interface
gem 'administrate'

# Bundler fix
gem 'sys-proctable'
gem 'ffi'

group :production do
  gem 'rails_12factor'
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
  gem 'pry'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'rails_real_favicon'
end

