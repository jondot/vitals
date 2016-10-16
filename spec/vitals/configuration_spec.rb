require 'spec_helper'

describe Vitals::Configuration do
  before do
    @rack_env = ENV['RACK_ENV']
  end

  after do
    ENV['RACK_ENV'] = @rack_env
  end

  it 'should autodiscover env' do
    c = Vitals::Configuration.new
    c.environment.must_equal(ENV['RACK_ENV'] || 'development')

    ENV['RACK_ENV'] = 'production'
    c = Vitals::Configuration.new
    c.environment.must_equal('production')
  end

  it 'must autodiscover host' do
    c = Vitals::Configuration.new
    c.host.must_equal(`hostname -s`.chomp)
  end
end
