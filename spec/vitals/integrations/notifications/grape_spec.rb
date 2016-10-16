require 'spec_helper'
require 'vitals/integrations/notifications/grape'
require 'grape'

#
# Using real grape here because its notification abstraction
# requires mocking an endpoint, and a path, and a route and
# so on. Just use the real thing with rack-test.
#

describe Vitals::Integrations::Notifications::Grape do
  let(:reporter) { Vitals::Reporters::InmemReporter.new }
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

  describe 'grape notifications api' do
    include Rack::Test::Methods
    def app
      Class.new(Grape::API) do
        version 'v1', using: :path
        format :json
        prefix :api

        rescue_from StandardError do |_e|
          error! 'foobar'
        end

        get :raise_error do
          fail StandardError, 'Oh noes!'
        end

        get :make_error do
          error! 'foobar'
        end

        resource :statuses do
          get :public_timeline do
            sleep 0.1
            'hello world'
          end
        end

        resource :auth do
          http_basic do |_u, _p|
            false
          end

          get :secret do
            'impossible to get here'
          end
        end
      end
    end

    it 'handles grape errors via raise, catch all' do
      get '/api/v1/raise_error'
      last_response.ok?.must_equal(false)
      last_response.status.must_equal 500
      # this fails:
      # reporter.reports[0][:timing].must_equal('grape.api.v1.raise_error.get.500.all')
      reporter.reports.count.must_equal 1
    end

    it 'handles grape errors via error!' do
      get '/api/v1/make_error'
      last_response.ok?.must_equal(false)
      last_response.status.must_equal 500
      reporter.reports[0][:timing].must_equal('grape.api.v1.make_error.get.500.all')
      reporter.reports.count.must_equal 1
    end

    it 'handles grape\'s http_basic middleware' do
      get '/api/v1/auth/secret'
      last_response.ok?.must_equal(false)
      last_response.status.must_equal 401
      # grape notification doesn't register if not auth'd :(
      reporter.reports.count.must_equal 0
    end

    it 'handles prefix, version and format' do
      get '/api/v1/statuses/public_timeline'
      last_response.ok?.must_equal(true)

      reporter.reports.count.must_equal(1)
      report = reporter.reports[0]
      report[:timing].must_equal('grape.api.v1.statuses.public_timeline.get.200.all')
      report[:val].must_be_within_delta(100, 40)
    end

    describe 'use a non-dot path separator' do
      before do
        Vitals.configure! do |c|
          c.reporter = reporter
          c.path_sep = '__'
        end
      end

      it 'handles prefix, version and format' do
        get '/api/v1/statuses/public_timeline'
        last_response.ok?.must_equal(true)

        reporter.reports.count.must_equal(1)
        report = reporter.reports[0]
        report[:timing].must_equal('grape.api__v1__statuses__public_timeline.get.200.all')
        report[:val].must_be_within_delta(100, 40)
      end
    end
  end

  describe 'grape nonversioned notifications api' do
    include Rack::Test::Methods
    def app
      Class.new(Grape::API) do
        format :json
        resource :statuses do
          get :public_timeline do
            sleep 0.1
            'hello world'
          end
        end
      end
    end

    it 'handles default api' do
      get '/statuses/public_timeline'
      last_response.ok?.must_equal(true)
      reporter.reports.count.must_equal(1)
      report = reporter.reports[0]
      report[:timing].must_equal('grape.statuses.public_timeline.get.200.all')
      report[:val].must_be_within_delta(100, 40)
    end
  end
end
