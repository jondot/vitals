require 'spec_helper'

describe Acme::API do
  include Rack::Test::Methods

  def app
    Acme::API
  end
  before do
    Vitals.reporter.flush
  end

  it 'GET ring' do
    get '/api/ring'
    expect(JSON.parse(last_response.body)[:rang].to_i).to be >= 0
    metrics = %w{
      grape.api.ring.get.200.all
    }
    assert_timings Vitals.reporter.reports, metrics, [0]
  end
end
