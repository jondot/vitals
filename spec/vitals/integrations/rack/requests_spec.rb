require 'spec_helper'
require 'vitals/integrations/rack/requests'
require 'sinatra/base'

#
# Using real grape here because its notification abstraction
# requires mocking an endpoint, and a path, and a route and
# so on. Just use the real thing with rack-test.
#
class SinatraTestAPI < Sinatra::Base
  use Vitals::Integrations::Rack::Requests

  get '/foo/bar/baz' do
    sleep 0.1
    "hello get"
  end

  post '/foo/bar/:name' do
    sleep 0.1
    "hello post"
  end
end


describe Vitals::Integrations::Rack::Requests do
  let(:reporter){Vitals::Reporters::InmemReporter.new}
  before do
    reporter.flush
    Vitals.configure! do |c|
      c.reporter = reporter
    end
  end

  describe SinatraTestAPI do
    include Rack::Test::Methods
    def app
      SinatraTestAPI
    end

    it 'handles get' do
      get '/foo/bar/baz'
      last_response.ok?.must_equal(true)

      reporter.reports.count.must_equal(1)
      report = reporter.reports[0]
      report[:timing].must_equal('requests._foo_bar_baz.get.200')
      report[:val].must_be_within_delta(100, 20)
    end

    it 'handles post' do
      post '/foo/bar/baz'
      last_response.ok?.must_equal(true)

      reporter.reports.count.must_equal(1)
      report = reporter.reports[0]
      report[:timing].must_equal('requests._foo_bar_baz.post.200')
      report[:val].must_be_within_delta(100, 20)
    end
  end
end

