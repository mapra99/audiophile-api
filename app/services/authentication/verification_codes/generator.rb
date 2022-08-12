module Authentication
  module VerificationCodes
    class Generator
      attr_reader :verification_code

      EXPIRATION_TIME = 5.minutes
      VERIFICATION_CODE_EMAIL_TEMPLATE = 'd-8dfeebf382ed485fac8c67bb35617c2d'.freeze

      def initialize(user:)
        self.user = user
      end

      def call
        create_code
        schedule_expiration
        send_email
      end

      private

      attr_accessor :user, :raw_code
      attr_writer :verification_code

      def create_code
        self.raw_code = format('%06d', rand(0..999_999))
        self.verification_code = VerificationCode.create!(
          user: user,
          code: raw_code,
          expires_at: EXPIRATION_TIME.from_now,
          status: VerificationCode::STARTED
        )
      rescue ActiveRecord::RecordInvalid => e
        raise InvalidCode, [e.message]
      end

      def schedule_expiration
        ExpirationScheduler.new(
          verification_code: verification_code,
          wait_time: EXPIRATION_TIME
        ).call
      end

      def send_email
        Communications::EmailSenderJob.perform_later(
          topic: Communication::VERIFICATION_CODE_TOPIC,
          sender: EmailCommunication::AUTH_SENDER_EMAIL,
          recipient: user.email,
          template_id: VERIFICATION_CODE_EMAIL_TEMPLATE,
          template_data: {
            user_name: user.name,
            verification_code: raw_code
          },
          target: user
        )
      end
    end
  end
end
