require 'spec_helper'
require 'vitals/integrations/notifications/action_controller'

describe Vitals::Integrations::Notifications::ActionController do
  let(:reporter){Vitals::Reporters::InmemReporter.new}

  before do
    reporter.flush
    Vitals.configure! do |c|
      c.reporter = reporter
    end
    @sub = Vitals::Integrations::Notifications::ActionController.subscribe!
  end

  after do
    ActiveSupport::Notifications.unsubscribe(@sub)
  end

  it 'handle notifications' do
    ActiveSupport::Notifications.instrument('process_action.action_controller',
                                            {
                                              method: 'GET',
                                              status: 200,
                                              action: 'new',
                                              controller: 'RegistrationsController',
                                              db_runtime: 12,
                                              view_runtime: 30
                                            }) do
                                              sleep 0.1
                                            end

    reporter.reports.count.must_equal(3)
    report = reporter.reports[0]
    report[:timing].must_equal('controllers.registrations.new.get.200.all')
    report[:val].must_be_within_delta(100, 50)

    report = reporter.reports[1]
    report[:timing].must_equal('controllers.registrations.new.get.200.db')
    report[:val].must_equal(12)

    report = reporter.reports[2]
    report[:timing].must_equal('controllers.registrations.new.get.200.view')
    report[:val].must_equal(30)
  end
end

