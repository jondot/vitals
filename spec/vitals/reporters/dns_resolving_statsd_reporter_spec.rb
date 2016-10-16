require 'spec_helper'

describe Vitals::Reporters::DnsResolvingStatsdReporter do
  it 'successfully creates a statsd object when using localhost' do
    reporter = Vitals::Reporters::DnsResolvingStatsdReporter.new(host: 'localhost', port: 8125, format: TestFormat.new)

    assert_equal reporter.statsd.host, 'localhost'
  end

  it 'successfully creates a statsd object when using ip address' do
    reporter = Vitals::Reporters::DnsResolvingStatsdReporter.new(host: '127.0.0.1', port: 8125, format: TestFormat.new)

    assert_equal reporter.statsd.host, '127.0.0.1'
  end

  describe 'with domain name' do
    FIRST_QUERY_RESULT = '10.0.0.1'.freeze
    SUBSEQUENT_QUERY_RESULT = '10.0.0.2'.freeze

    class StatsdMockDns < Vitals::Reporters::DnsResolvingStatsdReporter
      def query_dns
        result = @called ? [SUBSEQUENT_QUERY_RESULT, 1] : [FIRST_QUERY_RESULT, 1]
        @called = true
        result
      end
    end

    let(:reporter) { StatsdMockDns.new(host: 'example.com', port: 8125, format: TestFormat.new) }

    it 'creates statsd with ip address' do
      assert_equal reporter.statsd.host, FIRST_QUERY_RESULT
    end

    it 'creates new statsd object when DNS query changes' do
      old_statsd_obj = reporter.statsd
      sleep 1.5 # enough to make the first tick of the sleep happen

      assert_equal reporter.statsd.host, SUBSEQUENT_QUERY_RESULT
      assert old_statsd_obj.object_id != reporter.statsd.object_id
    end

    it "doesn't create new statsd object with each TTL if no changes" do
      reporter.statsd
      sleep 1.5 # enough to make the first tick of the sleep happen
      old_statsd_obj = reporter.statsd
      sleep 1
      assert_equal reporter.statsd.object_id, old_statsd_obj.object_id
    end
  end
end
