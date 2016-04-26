#TODO: ERROR Table 'notifs' already exists
# Delete old database
db_path = File.dirname(__FILE__) + '/internal/db/combustion_test.sqlite'
File.delete(db_path) if File.exist?(db_path)

# Coverage
require 'simplecov'
require 'coveralls'

SimpleCov.minimum_coverage 90
SimpleCov.minimum_coverage_by_file 80
SimpleCov.add_filter '/spec/user_notif/'
SimpleCov.add_filter 'user_notif_spec.rb'

SimpleCov.formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

SimpleCov.at_exit do
  Dir.mkdir('coverage') unless Dir.exist?('coverage')
  SimpleCov.result.format!
end

SimpleCov.start

# Combustion
require 'combustion'
require 'rails/generators'

Combustion.initialize! :all

# Running install generator
Rails::Generators.invoke('user_notif:install')

# Tests
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'user_notif'

ActionMailer::Base.delivery_method = :test
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.deliveries = []