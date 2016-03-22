require 'vitals'

Vitals.configure! do |c|
  c.facility = 'rails_42'
end

require 'vitals/integrations/notifications/action_controller'
Vitals::Integrations::Notifications::ActionController.subscribe!

require 'vitals/integrations/notifications/active_job'
Vitals::Integrations::Notifications::ActiveJob.subscribe!

