source 'https://rubygems.org'

ruby '3.0.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '6.1.5'

gem 'bootsnap'
# Use sqlite3 as the database for Active Record
#gem 'sqlite3'
# Use SCSS for stylesheets
gem 'sassc-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'execjs'
#gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
#gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', group: :doc

gem 'pg'
gem 'rexml'
gem 'libxml-xmlrpc'
gem 'devise'
gem 'omniauth', '1.9.1'
gem 'omniauth-google-oauth2'
gem "omniauth-rails_csrf_protection"
gem 'unicorn-rails'

gem 'nrb-beerxml', git: 'https://github.com/ollej/beerxml.git', ref: '3c3a9c6d7b138a1160e481f276bb2d0923c83911'
gem 'beer_recipe' #, path: './vendor/beer_recipe/'
gem 'commontator'
gem 'acts_as_votable'
gem 'search_cop', git: 'https://github.com/mrkamel/search_cop.git', ref: '1082a2f7862321cf8f1c4560a2b6602a0c256e59' # Use Ruby v2.4 compatible fork
gem 'meta-tags'
gem 'pushover', git: 'https://github.com/vito-lbs/pushover.git', ref: '3bbb7ea026b3d30c043ba033d596dab6fec2a031' # Use Ruby v2.4 compatible fork
gem "kt-paperclip"
gem 'chronic', require: true
gem 'actionview-encoded_mail_to'
gem 'quilljs-rails'
gem 'csv_shaper'
gem 'caxlsx'
gem 'caxlsx_rails'
gem 'dotenv-rails'
gem 'httparty'
gem "lograge"

# PDF
gem 'rqrcode'
gem 'prawn'
gem 'prawn-svg'
gem 'word_wrap'

# spam protection
gem 'invisible_captcha'
gem 'project_honeypot'
gem 'rack-attack'
gem 'recaptcha', require: 'recaptcha/rails'
gem 'geocoder'
gem 'humanizer', git: 'https://github.com/kiskolabs/humanizer', ref: 'c7789fb1f422922e7fd735346c13501ce7490ed8' # Includes fix for frozen hash

# Admin interface
gem 'administrate'
gem 'administrate-field-image'
gem 'administrate-field-jsonb'

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
  gem 'rspec-rails'
  gem 'rails-controller-testing'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'rails_real_favicon'
  gem 'listen'
end

