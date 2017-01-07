require 'rspec/core'
require 'rack/test'
ENV['RACK_ENV'] = 'test'
require './application/api'
require 'faker'
require 'factory_girl'
require 'sucker_punch/testing/inline'

FactoryGirl.definition_file_paths = %w{./application/spec/factories}
FactoryGirl.find_definitions

FactoryGirl.define do
  to_create(&:save) # Sequel support
end

module RSpecHelpers
  include Rack::Test::Methods

  def login_as user
    Api.class_variable_set(:@@current_user, user)
  end

  def app
    Api
  end

  def response
    last_response
  end

  def response_body
    JSON.parse(response.body, symbolize_names: true)
  end

  def get_scope opts = {}
    scope = Api.new
    scope.instance_variable_set(:@current_user, opts[:as_user])
    scope
  end
end

class Api
  helpers do
    def current_user
      begin
        @current_user = Api.class_variable_get(:@@current_user)
      rescue
        nil
      end
    end
  end
end

SEQUEL_DB = Api::SEQUEL_DB
# Clear old test data
SEQUEL_DB.tables.each do |t|
  # we don't want to clean the schema_migrations table
  SEQUEL_DB.from(t).truncate unless t == :schema_migrations || t.to_s.match(/^oauth_/)
end

Faker::Config.locale = 'en-US'

Mail.defaults do
  delivery_method :test
end

RSpec.configure do |config|
  config.extend RSpecHelpers
  config.include RSpecHelpers
  config.include FactoryGirl::Syntax::Methods
  config.include Mail::Matchers
  config.filter_run_excluding :slow
  config.color = true
  config.tty = true
  config.formatter = :documentation
  config.order = :random
  Kernel.srand config.seed

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before(:each) do
    SuckerPunch::Queue.clear
    Mail::TestMailer.deliveries.clear
    login_as(nil)
  end

  config.around(:all) do |example|
    Sequel.transaction [SEQUEL_DB], rollback: :always do
      example.run
    end
  end

  config.around(:each) do |example|
    Sequel.transaction([SEQUEL_DB], rollback: :always, savepoint: true, auto_savepoint: true) do
      example.run
    end
  end
end
