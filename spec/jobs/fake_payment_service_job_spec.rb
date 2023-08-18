require 'rails_helper'

RSpec.describe FakePaymentServiceJob, type: :job do
  describe '#perform_later' do

    it 'enqueue a job' do
      ActiveJob::Base.queue_adapter = :test
      expect { FakePaymentServiceJob.perform_later }.to have_enqueued_job
    end
  end
end
