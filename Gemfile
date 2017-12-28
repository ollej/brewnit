source 'https://rubygems.org'

ruby '2.5.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.1.4'
# Use sqlite3 as the database for Active Record
#gem 'sqlite3'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
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
gem 'jbuilder'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', group: :doc

gem 'pg'
gem 'libxml-xmlrpc'
gem 'devise'
gem 'omniauth-google-oauth2'
gem 'unicorn-rails'

gem 'nrb-beerxml', git: 'https://github.com/ollej/beerxml.git', ref: '3c3a9c6d7b138a1160e481f276bb2d0923c83911'
gem 'beer_recipe' #, path: './vendor/beer_recipe/'
gem 'commontator'
gem 'acts_as_votable'
gem 'search_cop', git: 'https://github.com/mrkamel/search_cop.git', ref: '1082a2f7862321cf8f1c4560a2b6602a0c256e59' # Use Ruby v2.4 compatible fork
gem 'meta-tags'
gem 'pushover', git: 'https://github.com/vito-lbs/pushover.git', ref: '3bbb7ea026b3d30c043ba033d596dab6fec2a031' # Use Ruby v2.4 compatible fork
gem 'paperclip'
gem 'fancybox2-rails', git: 'https://github.com/ChallahuAkbar/fancybox2-rails.git', ref: '34a70fa57148bc74bedc896df8e37fb56d136e5b' # Use rails5 compatible fork
gem 'chronic', require: true
gem 'actionview-encoded_mail_to'
gem 'quilljs-rails'
gem 'csv_shaper'
gem 'axlsx', git: 'https://github.com/randym/axlsx.git', ref: 'c8ac844572b25fda358cc01d2104720c4c42f450'
gem 'axlsx_rails'
gem 'dotenv-rails'
gem 'httparty'

# spam protection
gem 'invisible_captcha'
gem 'project_honeypot'
gem 'rack-attack'
gem 'recaptcha', require: 'recaptcha/rails'

# Admin interface
gem 'administrate'
gem 'administrate-field-image'

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

