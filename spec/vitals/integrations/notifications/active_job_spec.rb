require 'spec_helper'
require 'vitals/integrations/notifications/active_job'

describe Vitals::Integrations::Notifications::ActiveJob do
  let(:reporter) { Vitals::Reporters::InmemReporter.new }
  before do
    reporter.flush
    Vitals.configure! do |c|
      c.reporter = reporter
    end
    @sub = Vitals::Integrations::Notifications::ActiveJob.subscribe!
  end
  after do
    ActiveSupport::Notifications.unsubscribe(@sub)
  end

  it 'handle notifications' do
    class FooBarWorker
      def queue_name
        'foobarqueue_workers'
      end
    end

    class FooBarJob
      def queue_name
        'foobarqueue_jobs'
      end
    end

    ActiveSupport::Notifications.instrument('perform.active_job',
                                            {
                                              job: FooBarWorker.new
                                            }) do
                                              sleep 0.1
                                            end

    reporter.reports.count.must_equal(1)
    report = reporter.reports.first
    report[:timing].must_equal('jobs.foobarqueue_workers.foobar')
    report[:val].must_be_within_delta(100, 50)
    reporter.flush

    ActiveSupport::Notifications.instrument('perform.active_job',
                                            {
                                              job: FooBarJob.new
                                            }) do
                                              sleep 0.1
                                            end

    reporter.reports.count.must_equal(1)
    report = reporter.reports.first
    report[:timing].must_equal('jobs.foobarqueue_jobs.foobar')
    report[:val].must_be_within_delta(100, 50)
  end
end
