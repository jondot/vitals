require 'spec_helper'
require 'vitals/integrations/rack/requests'
require 'sinatra/base'

#
# Using real grape here because its notification abstraction
# requires mocking an endpoint, and a path, and a route and
# so on. Just use the real thing with rack-test.
#

describe Vitals::Integrations::Rack::Requests do
  let(:reporter){Vitals::Reporters::InmemReporter.new}
  before do
    reporter.flush
    Vitals.configure! do |c|
      c.reporter = reporter
    end
  end

  describe "grape rack non-versioned api" do
    include Rack::Test::Methods
    def app
      Class.new(Grape::API) do
        use Vitals::Integrations::Rack::Requests
        resource :statuses do
          get :public_timeline do
            sleep 0.1
            "hello world"
          end
        end
      end
    end

    it 'handles get' do
      get "/statuses/public_timeline"
      last_response.ok?.must_equal(true)

      reporter.reports.count.must_equal(1)
      report = reporter.reports[0]
      report[:timing].must_equal('requests.statuses.public_timeline.get.200')
      report[:val].must_be_within_delta(100, 20)
    end
  end

  describe "grape rack versioned api" do
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
            "hello world"
          end
        end
      end
    end

    it 'handles get' do
      get "/api/v1/statuses/public_timeline"
      last_response.ok?.must_equal(true)

      reporter.reports.count.must_equal(1)
      report = reporter.reports[0]
      report[:timing].must_equal('requests.api.v1.statuses.public_timeline.get.200')
      report[:val].must_be_within_delta(100, 20)
    end
  end

  describe "sinatra rack api" do
    include Rack::Test::Methods
    def app
      Class.new(Sinatra::Base) do
        use Vitals::Integrations::Rack::Requests

        get '/foo/bar/baz' do
          sleep 0.1
          "hello get"
        end

        post '/foo/bar/:name' do
          sleep 0.1
          "hello post"
        end

        post '/posts/:id/comments' do
          sleep 0.1
          "posts"
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
      report[:val].must_be_within_delta(100, 20)
    end
  end
end

