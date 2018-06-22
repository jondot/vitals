require 'test_helper'
require 'active_support/log_subscriber/test_helper'
require 'action_controller/log_subscriber'

class TestLogSubscriber < ActiveSupport::LogSubscriber
  cattr_accessor :event

  def process_action event
    self.class.event = event
  end

  def self.controller_times
    dbtime, viewtime =  event.payload.slice(:db_runtime, :view_runtime).values
    viewtime ||= 0
    dbtime ||= 0
    # all time is simulated. we don't get the 'all' time here.
    [dbtime+viewtime, dbtime, viewtime]
  end

  def self.flush
    self.event = nil
  end
end

class VitalsFlowTest < ActionDispatch::IntegrationTest
  setup do
    Vitals.reporter.flush
    TestLogSubscriber.flush
    TestLogSubscriber.attach_to :action_controller
  end

  test "get posts with rack middleware" do
    get '/posts'
    metrics = %w{
      controllers.posts.index.get.200.all
      controllers.posts.index.get.200.db
      controllers.posts.index.get.200.view
      requests.posts_index.get.200
    }

    assert_timings Vitals.reporter.reports,
                   metrics,
                   TestLogSubscriber.controller_times+[-1],
                   60
  end

  test "get new which also triggers a job" do
    get '/posts/new'

    metrics = %w{
      jobs.default.foobarcleanup
      controllers.posts.new.get.200.all
      controllers.posts.new.get.200.db
      controllers.posts.new.get.200.view
      requests.posts_new.get.200
    }

    assert_timings Vitals.reporter.reports,
                   metrics,
                   [-1]+TestLogSubscriber.controller_times+[-1],
                   60

  end

  test "get posts" do
    get '/posts'

    metrics = %w{
      controllers.posts.index.get.200.all
      controllers.posts.index.get.200.db
      controllers.posts.index.get.200.view
      requests.posts_index.get.200
    }

    assert_timings Vitals.reporter.reports,
                   metrics,
                   TestLogSubscriber.controller_times+[-1],
                   80
  end

  test "post posts" do
    post '/posts', post: { title: 'foobar'}

    metrics = %w{
      controllers.posts.create.post.302.all
      controllers.posts.create.post.302.db
      requests.posts_create.post.302
    }

    assert_timings Vitals.reporter.reports,
                   metrics,
                   TestLogSubscriber.controller_times+[-1],
                   80
  end

end
