# configure statsd host and port.
<%= Rails.application.class.to_s %>.configure do
  config.vitals.enabled = true
  config.vitals.host = '<%= options[:host] || 'localhost' %>'
  config.vitals.port = <%= options[:port] || 8125 %>
end

