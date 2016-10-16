require 'statsd-ruby'
require 'resolv'

module Vitals::Reporters
  class DnsResolvingStatsdReporter < StatsdReporter
    def initialize(host: 'localhost', port: 8125, format: nil)
      @host = host
      @port = port
      @format = format
      setup_statsd
    end

    private

    def setup_statsd
      ip = @host
      unless @host =~ Resolv::AddressRegex || @host == 'localhost'.freeze
        ip, ttl = query_dns
        Thread.new do
          loop do
            sleep ttl
            previous_ip = ip
            ip, ttl = query_dns
            @statsd = Statsd.new(ip, @port) if ip != previous_ip
          end
        end
      end
      @statsd = Statsd.new(ip, @port)
    end

    def query_dns
      ress = Resolv::DNS.open { |dns| dns.getresource(@host, Resolv::DNS::Resource::IN::A) }
      [ress.address.to_s, ress.ttl]
    end
  end
end
