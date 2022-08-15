module Authentication
  module AccessTokens
    class ExpirationScheduler
      attr_reader :access_token

      def initialize(access_token:, wait_time:)
        self.access_token = access_token
        self.wait_time = wait_time
      end

      def call
        kill_existing_job
        schedule_new_job
        update_access_token
      end

      private

      attr_accessor :new_job, :wait_time
      attr_writer :access_token

      def kill_existing_job
        return unless access_token.expiration_job_id

        RevokerJob.kill!(access_token.expiration_job_id)
      end

      def schedule_new_job
        self.new_job = RevokerJob.set(wait: wait_time).perform_later(access_token.id)
      end

      def update_access_token
        access_token.update!(expiration_job_id: new_job.provider_job_id)
      end
    end
  end
end
