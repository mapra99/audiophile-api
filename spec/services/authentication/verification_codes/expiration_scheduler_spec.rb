require 'rails_helper'

RSpec.describe Authentication::VerificationCodes::ExpirationScheduler do
  subject(:scheduler) { described_class.new(verification_code: verification_code, wait_time: wait_time) }

  let(:verification_code) { create(:verification_code) }
  let(:wait_time) { 5.minutes }

  describe '#call' do
    let(:job_id) { '123abc' }
    let(:scheduled_job) { instance_double('Scheduled Job', provider_job_id: '123abc') }
    let(:revoker_job) { class_double('RevokerJob', perform_later: scheduled_job) }

    describe 'when successful' do
      before do
        allow(Authentication::VerificationCodes::RevokerJob).to receive(:set).and_return(revoker_job)

        scheduler.call
      end

      it 'schedules the job' do
        expect(Authentication::VerificationCodes::RevokerJob).to have_received(:set).with(wait: wait_time)
      end

      it 'saves the expiration job id' do
        expect(scheduler.verification_code.expiration_job_id).to eq(job_id)
      end
    end

    describe 'when the code already has an expiration job' do
      let(:current_job_id) { '456def' }
      let(:verification_code) { create(:verification_code, expiration_job_id: current_job_id) }

      before do
        allow(Authentication::VerificationCodes::RevokerJob).to receive(:set).and_return(revoker_job)
        allow(Authentication::VerificationCodes::RevokerJob).to receive(:kill!).and_return(true)

        scheduler.call
      end

      it 'kills the actual job' do
        expect(Authentication::VerificationCodes::RevokerJob).to have_received(:kill!).with(current_job_id)
      end
    end
  end
end
