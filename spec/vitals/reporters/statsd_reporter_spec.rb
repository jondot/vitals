require 'spec_helper'

describe Vitals::Reporters::StatsdReporter do
  let(:reporter) { Vitals::Reporters::StatsdReporter.new(host: 'localhost', port: 8125, format: TestFormat.new) }

  it 'should set up statsd' do
    skip('implement')
  end

  it '#inc' do
    mock(reporter.statsd).increment('1.2').times(1)
    reporter.inc('1.2')
  end

  it '#count' do
    mock(reporter.statsd).count('1.2', 32).times(1)
    reporter.count('1.2', 32)
  end

  it '#timing' do
    mock(reporter.statsd).timing('1.2', 42).times(1)
    reporter.timing('1.2', 42)
  end

  it '#gauge' do
    mock(reporter.statsd).gauge('1.2', 32).times(1)
    reporter.gauge('1.2', 32)
  end
end
