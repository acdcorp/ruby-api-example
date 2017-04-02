Encoding.default_external = 'UTF-8'

$LOAD_PATH.unshift(File.expand_path('./application'))

# Include critical gems
require 'config/variables'

if %w(development test).include?(RACK_ENV)
  require 'pry'
  require 'awesome_print'
end

require 'bundler'
Bundler.setup :default, RACK_ENV
require 'rack/indifferent'
require 'grape'
require 'grape/batch'
require 'sucker_punch'
require 'mail'
require 'jwt'
# Initialize the application so we can add all our components to it
class Api < Grape::API; end

# Include all config files
require 'config/sequel'
require 'config/hanami'
require 'config/grape'
require 'config/mail'

# require some global libs
require 'lib/core_ext'
require 'lib/time_formats'
require 'lib/io'
require 'lib/pretty_logger'
require 'lib/operation'

# load active support helpers
require 'active_support'
require 'active_support/core_ext'

# require application classes
require './application/operations/user_operation'

Dir['./application/models/*.rb'].each { |rb| require rb }
Dir['./application/entities/*.rb'].each { |rb| require rb }
Dir['./application/jobs/*.rb'].each { |rb| require rb }
Dir['./application/validators/*.rb'].each { |rb| require rb }
Dir['./application/operations/*.rb'].each { |rb| require rb }
Dir['./application/api_helpers/**/*.rb'].each { |rb| require rb }

class Api < Grape::API
  version 'v1.0', using: :path
  content_type :json, 'application/json'
  content_type :txt, 'text/plain'
  default_format :json
  prefix :api

  logger PrettyLogger.logger

  rescue_from Grape::Exceptions::ValidationErrors do |e|
    ret = { error_type: 'validation', errors: {} }
    e.each do |x, err|
      ret[:errors][x[0]] ||= []
      ret[:errors][x[0]] << err.message
    end
    error! ret, 400
  end

  rescue_from Sequel::NoMatchingRow do |e|
    error!({ error_type: 'not_found' }, 404)
  end

  rescue_from :all do |e|
    Api.logger.error(e.class)
    Api.logger.error(e.message)
    Api.logger.error(e.backtrace.join("\n"))
    error!({ error_type: 'internal' }, 500)
  end

  helpers SharedParams
  helpers ApiResponse
  include Auth

  before do
    header['Access-Control-Allow-Origin'] = '*'
    header['Access-Control-Request-Method'] = '*'

    authenticate!
  end

  Dir['./application/api_entities/**/*.rb'].each { |rb| require rb }
  Dir['./application/api/**/*.rb'].each { |rb| require rb }

  add_swagger_documentation mount_path: '/docs'
end
