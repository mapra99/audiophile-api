module Authentication
  module VerificationCodes
    class Checker
      attr_reader :verification_code

      def initialize(user:, code:)
        self.user = user
        self.code = code
      end

      def call
        find_started_codes
        match_code
        update_status
        kill_expiration_job
      end

      private

      attr_accessor :user, :code, :started_codes
      attr_writer :verification_code

      def find_started_codes
        self.started_codes = user.verification_codes.started
        raise NoStartedCodes, user.id if started_codes.blank?
      end

      def match_code
        matching_code = started_codes.find { |started_code| started_code.authenticate_code(code) }
        raise IncorrectCode.new(user.id, code) if matching_code.blank?

        self.verification_code = matching_code
      end

      def update_status
        verification_code.update!(status: VerificationCode::USED)
      end

      def kill_expiration_job
        RevokerJob.kill!(verification_code.expiration_job_id)
      end
    end
  end
end
