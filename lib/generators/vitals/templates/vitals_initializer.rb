# configure statsd host and port.
<%= Rails.application.class.to_s %>.config do |c|
  c.vitals.enabled = true
  c.vitals.host = '<%= options[:host] || 'localhost' %>'
  c.vitals.port = <%= options[:port] || 8125 %>
end

