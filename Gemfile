source 'https://rubygems.org'


gem 'rails', '4.2.0'
gem 'mysql2'
gem 'sass-rails', '~> 5.0.0.beta1'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'

# Search
gem 'searchkick'
# fast and reliable requests (offered by searchkick)
gem 'typhoeus'

# Autocomplete search terms
gem 'rack-contrib'
gem 'soulmate', :require => 'soulmate/server'

# front end
gem "slim-rails"
gem 'susy'
gem 'compass-rails', '~> 2.0.4'
gem 'breakpoint', '~> 2.5.0'
gem "font-awesome-rails"

gem 'jquery-rails'
#gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'sprig', '~> 0.1'

# Background processing
gem 'sidekiq'

# Authentication
gem 'devise'

# Recommendation
gem 'recommendable'

# Reputation
gem 'activerecord-reputation-system'

# SEO
gem 'friendly_id', '~> 5.1.0'
gem 'babosa'
gem 'breadcrumble'

# Tips
gem 'active_link_to'
# Live editing
gem 'best_in_place', '~> 3.0.1', :git => 'https://github.com/Lesuk/best_in_place.git'
# Pagination
gem 'kaminari'

gem 'acts_as_list'

gem 'counter_culture', '~> 0.1.23'

# Quizzes
gem 'survey', '~> 0.2'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  gem 'spring'

  # Code Quality
  gem "rails_best_practices"

  gem 'better_errors'
  gem 'lol_dba'
  # finds dead routes and unused actions
  gem 'traceroute'

  # Entity-Relationship Diagrams
  gem "rails-erd"

  # model and controller UML class diagram generator
  gem 'railroady'
end

group :production do
	gem 'pg'
end
