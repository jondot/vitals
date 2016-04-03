require 'spec_helper'

describe Acme::Ping do
  before do
    Vitals.reporter.flush
  end
  it 'ping' do
    get '/api/ping'
    metrics = %w{
      grape.api.ping.get.200.all
    }
    assert_timings Vitals.reporter.reports, metrics, [0]
    expect(response.body).to eq({ ping: 'pong' }.to_json)
  end
end
