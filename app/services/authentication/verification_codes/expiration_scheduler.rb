module Authentication
  module VerificationCodes
    class ExpirationScheduler
      attr_reader :verification_code

      def initialize(verification_code:, wait_time:)
        self.verification_code = verification_code
        self.wait_time = wait_time
      end

      def call
        kill_existing_job
        schedule_new_job
        update_verification_code
      end

      private

      attr_accessor :new_job, :wait_time
      attr_writer :verification_code

      def kill_existing_job
        return unless verification_code.expiration_job_id

        RevokerJob.kill!(verification_code.expiration_job_id)
      end

      def schedule_new_job
        self.new_job = RevokerJob.set(wait: wait_time).perform_later(verification_code.id)
      end

      def update_verification_code
        verification_code.update!(expiration_job_id: new_job.provider_job_id)
      end
    end
  end
end
