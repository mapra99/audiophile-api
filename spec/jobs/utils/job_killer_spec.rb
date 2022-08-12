require 'rails_helper'

class ExampleJob < ApplicationJob
  extend Utils::JobKiller
end

RSpec.describe Utils::JobKiller, type: :job do
  let(:job) { ExampleJob.set(wait: 1.week).perform_later }
  let(:sidekiq_job_id) { job.provider_job_id }

  describe '.kill!' do
    before do
      sidekiq_job_id
    end

    it 'kills the enqueued job' do
      expect { ExampleJob.kill!(sidekiq_job_id) }.to change { Sidekiq::ScheduledSet.new.size }.by(-1)
    end

    describe 'when the job id does not exist' do
      let(:sidekiq_job_id) { 'abc123' }

      it 'raises an error' do
        expect { ExampleJob.kill!(sidekiq_job_id) }.to raise_error(Jobs::JobNotFound)
      end
    end
  end
end
