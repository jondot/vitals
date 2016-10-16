require 'spec_helper'
require 'vitals/integrations/rack/requests'
require 'sinatra/base'

#
# Using real grape here because its notification abstraction
# requires mocking an endpoint, and a path, and a route and
# so on. Just use the real thing with rack-test.
#

describe Vitals::Integrations::Rack::Requests do
  let(:reporter) { Vitals::Reporters::InmemReporter.new }
  before do
    reporter.flush
    Vitals.configure! do |c|
      c.reporter = reporter
    end
  end

  describe 'grape rack non-versioned api' do
    include Rack::Test::Methods
    def app
      Class.new(Grape::API) do
        use Vitals::Integrations::Rack::Requests
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

    it 'handles grape\'s http_basic middleware' do
      get '/auth/secret'
      last_response.ok?.must_equal(false)
      last_response.status.must_equal 401
      # grape notification doesn't register if not auth'd :(
      reporter.reports.count.must_equal(1)
      report = reporter.reports[0]
      report[:timing].must_equal('requests.auth.secret.get.401')
      report[:val].must_be_within_delta(2, 20)
    end

    it 'handles get' do
      get '/statuses/public_timeline'
      last_response.ok?.must_equal(true)

      reporter.reports.count.must_equal(1)
      report = reporter.reports[0]
      report[:timing].must_equal('requests.statuses.public_timeline.get.200')
      report[:val].must_be_within_delta(100, 50)
    end

    describe 'use a non-dot path separator' do
      before do
        reporter.flush
        Vitals.configure! do |c|
          c.reporter = reporter
        end
      end

      it 'handles get' do
        get '/statuses/public_timeline'
        last_response.ok?.must_equal(true)

        reporter.reports.count.must_equal(1)
        report = reporter.reports[0]
        report[:timing].must_equal('requests.statuses.public_timeline.get.200')
        report[:val].must_be_within_delta(100, 50)
      end
    end
  end

  describe 'grape rack versioned api' do
    include Rack::Test::Methods
    def app
      Class.new(Grape::API) do
        use Vitals::Integrations::Rack::Requests
        version 'v1', using: :path
        format :json
        prefix :api

        resource :statuses do
          get :public_timeline do
            sleep 0.1
            'hello world'
          end
        end
      end
    end

    it 'handles get' do
      get '/api/v1/statuses/public_timeline'
      last_response.ok?.must_equal(true)

      reporter.reports.count.must_equal(1)
      report = reporter.reports[0]
      report[:timing].must_equal('requests.api.v1.statuses.public_timeline.get.200')
      report[:val].must_be_within_delta(100, 20)
    end
  end

  describe 'rack api request prefix' do
    include Rack::Test::Methods
    def app
      Class.new(Sinatra::Base) do
        use(Class.new do
          def initialize(app, _options = {})
            @app = app
          end

          def call(env)
            env['vitals.req_prefix'] = 'foobar_req_prefix'
            @app.call(env)
          end
        end)
        use Vitals::Integrations::Rack::Requests

        get '/foo/bar/baz' do
          'hello get'
        end
      end
    end

    it 'handles get' do
      get '/foo/bar/baz'
      last_response.ok?.must_equal(true)

      reporter.reports.count.must_equal(1)
      report = reporter.reports[0]
      report[:timing].must_equal('requests.foobar_req_prefix.foo_bar_baz.get.200')
    end
  end

  describe 'sinatra wacky rack api' do
    include Rack::Test::Methods
    def app
      Class.new(Sinatra::Base) do
        use Vitals::Integrations::Rack::Requests

        get '/' do
          'hello get'
        end
      end
    end

    it 'handles a blank get' do
      get '/'
      last_response.ok?.must_equal(true)

      reporter.reports.count.must_equal(1)
      report = reporter.reports[0]
      report[:timing].must_equal('requests.get.200')
    end
  end

  describe 'sinatra rack api' do
    include Rack::Test::Methods
    def app
      Class.new(Sinatra::Base) do
        use Vitals::Integrations::Rack::Requests

        get '/foo/bar/baz' do
          sleep 0.1
          'hello get'
        end

        post '/foo/bar/:name' do
          sleep 0.1
          'hello post'
        end

        post '/posts/:id/comments' do
          sleep 0.1
          'posts'
        end
      end
    end

    it 'handles get' do
      get '/foo/bar/baz'
      last_response.ok?.must_equal(true)

      reporter.reports.count.must_equal(1)
      report = reporter.reports[0]
      report[:timing].must_equal('requests.foo_bar_baz.get.200')
      report[:val].must_be_within_delta(100, 20)
    end

    it 'handles post' do
      post '/foo/bar/baz'
      last_response.ok?.must_equal(true)

      reporter.reports.count.must_equal(1)
      report = reporter.reports[0]
      report[:timing].must_equal('requests.foo_bar__name.post.200')
      report[:val].must_be_within_delta(100, 20)
    end

    it 'gets a parameterized route' do
      post '/posts/242342/comments'
      last_response.ok?.must_equal(true)

      reporter.reports.count.must_equal(1)
      report = reporter.reports[0]
      report[:timing].must_equal('requests.posts__id_comments.post.200')
      report[:val].must_be_within_delta(100, 40)
    end
  end
end
