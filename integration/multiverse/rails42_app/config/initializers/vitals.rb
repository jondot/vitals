require 'vitals'

Vitals.configure! do |c|
  c.facility = 'rails_42'
end

require 'vitals/integrations/notifications/action_controller'
Vitals::Integrations::Notifications::ActionController.subscribe!

require 'vitals/integrations/notifications/active_job'
Vitals::Integrations::Notifications::ActiveJob.subscribe!

require 'vitals/integrations/rack/requests'
Rails.application.config.middleware.insert_before "Rails::Rack::Logger", Vitals::Integrations::Rack::Requests

