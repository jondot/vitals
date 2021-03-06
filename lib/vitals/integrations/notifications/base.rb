require 'active_support'

module Vitals::Integrations::Notifications
  class Base
    def self.subscribe!
      subscriber = ActiveSupport::Notifications.subscribe(event_name, &method(:handle))

      subscriber
    end

    def self.handle
      raise "#handle not implemented"
    end

    def self.duration(started, finished)
      Vitals::Utils.sec_to_ms(finished - started)
    end
  end
end

