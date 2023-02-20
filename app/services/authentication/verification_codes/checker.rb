module Authentication
  module VerificationCodes
    class Checker
      attr_reader :verification_code

      CHANNEL_VERIFIER_MAPPING = {
        VerificationCode::SMS_CHANNEL => Sms::CodeVerifier,
        VerificationCode::EMAIL_CHANNEL => Sms::EmailVerifier,
      }

      def initialize(user:, code:, channel:)
        self.user = user
        self.code = code
        self.channel = channel || VerificationCode::DEFAULT_CHANNEL
      end

      def call
        find_code
        verify_code
        update_status
        kill_expiration_job
      end

      private

      attr_accessor :user, :code, :channel
      attr_writer :verification_code

      def find_code
        self.verification_code = user.verification_codes.started.last
        raise NoStartedCodes, user.id if verification_code.blank?
      end

      def verify_code
        code_verifier.new(verification_code: verification_code, raw_code: code).call
      end

      def update_status
        verification_code.update!(status: VerificationCode::USED)
      end

      def kill_expiration_job
        RevokerJob.kill!(verification_code.expiration_job_id)
      end

      def code_verifier
        @code_verifier ||= CHANNEL_VERIFIER_MAPPING[channel]
      end
    end
  end
end
