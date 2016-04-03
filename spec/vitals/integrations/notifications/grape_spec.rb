require 'spec_helper'
require 'vitals/integrations/notifications/grape'
require 'grape'

#
# Using real grape here because its notification abstraction
# requires mocking an endpoint, and a path, and a route and
# so on. Just use the real thing with rack-test.
#

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

  describe "grape notifications api" do
    include Rack::Test::Methods
    def app
      Class.new(Grape::API) do
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
    end

    it 'handles prefix, version and format' do
      get "/api/v1/statuses/public_timeline"
      last_response.ok?.must_equal(true)

      reporter.reports.count.must_equal(1)
      report = reporter.reports[0]
      report[:timing].must_equal('grape.api.v1.statuses.public_timeline.get.200.all')
      report[:val].must_be_within_delta(100, 40)
    end
  end

  describe "grape nonversioned notifications api" do
    include Rack::Test::Methods
    def app
      Class.new(Grape::API) do
        format :json
        resource :statuses do
          get :public_timeline do
            sleep 0.1
            "hello world"
          end
        end
      end
    end

    it 'handles default api' do
      get "/statuses/public_timeline"
      last_response.ok?.must_equal(true)
      reporter.reports.count.must_equal(1)
      report = reporter.reports[0]
      report[:timing].must_equal('grape.statuses.public_timeline.get.200.all')
      report[:val].must_be_within_delta(100, 40)
    end
  end
end
