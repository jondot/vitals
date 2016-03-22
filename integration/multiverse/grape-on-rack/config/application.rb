$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'api'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'boot'

Bundler.require :default, ENV['RACK_ENV']

Dir[File.expand_path('../../api/*.rb', __FILE__)].each do |f|
  require f
end

require 'api'
require 'acme_app'

require 'vitals'
Vitals.configure! do |c|
  c.facility = 'grape_app'
end

require 'vitals/integrations/notifications/grape'
Vitals::Integrations::Notifications::Grape.subscribe!

