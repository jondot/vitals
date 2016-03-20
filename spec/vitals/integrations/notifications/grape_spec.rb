require 'spec_helper'
require 'vitals/integrations/notifications/grape'
require 'grape'

#
# Using real grape here because its notification abstraction
# requires mocking an endpoint, and a path, and a route and
# so on. Just use the real thing with rack-test.
#
module GrapeTestAPI
  class API < Grape::API
    version 'v1', using: :path
    format :json
    prefix :api

    resource :statuses do
      get :public_timeline do
        sleep 0.1
        "hello world"
      end
    end
  end

  class DefaultAPI < Grape::API
    format :json
    resource :statuses do
      get :public_timeline do
        sleep 0.1
        "hello world"
      end
    end
  end
end


describe Vitals::Integrations::Notifications::Grape do
  let(:reporter){Vitals::Reporters::InmemReporter.new}
  before do
    reporter.flush
    Vitals.configure! do |c|
      c.reporter = reporter
    end
    @sub = Vitals::Integrations::Notifications::Grape.subscribe!
  end

  after do
    ActiveSupport::Notifications.unsubscribe(@sub)
  end

  describe GrapeTestAPI::API do
    include Rack::Test::Methods
    def app
      ::GrapeTestAPI::API.new
    end

    it 'handles prefix, version and format' do
      get "/api/v1/statuses/public_timeline"
      last_response.ok?.must_equal(true)

      reporter.reports.count.must_equal(1)
      report = reporter.reports[0]
      report[:timing].must_equal('grape.api.v1.statuses.public_timeline_get.200.all')
      report[:val].must_be_within_delta(100, 20)
    end
  end

  describe GrapeTestAPI::DefaultAPI do
    include Rack::Test::Methods
    def app
      ::GrapeTestAPI::DefaultAPI.new
    end

    it 'handles default api' do
      get "/statuses/public_timeline"
      last_response.ok?.must_equal(true)
      reporter.reports.count.must_equal(1)
      report = reporter.reports[0]
      report[:timing].must_equal('grape.statuses.public_timeline_get.200.all')
      report[:val].must_be_within_delta(100, 20)
    end
  end
end
