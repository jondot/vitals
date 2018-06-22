require 'vitals/integrations/notifications/base'

module Vitals::Integrations::Notifications
  class ActionController < Base
    def self.event_name
      'process_action.action_controller'
    end

    private

    def self.handle(name, started, finished, unique_id, payload)
      method  = payload[:method].downcase
      status  = payload[:status]
      action  = payload[:action]
      ctrl    = payload[:controller].sub(/Controller$/, '').downcase
      # format  = payload[:format]

      m = "controllers.#{ctrl}.#{action}.#{method}.#{status}"
      Vitals.timing("#{m}.all", duration(started, finished))
      Vitals.timing("#{m}.db", payload[:db_runtime]) if payload[:db_runtime]
      Vitals.timing("#{m}.view", payload[:view_runtime]) if payload[:view_runtime]
    end

  end
end

