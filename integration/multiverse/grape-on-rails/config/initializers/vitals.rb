require 'vitals'
Vitals.configure! do |c|
    c.facility = 'grape_app'
end

require 'vitals/integrations/notifications/grape'
Vitals::Integrations::Notifications::Grape.subscribe!

