module Authentication
  module VerificationCodes
    class Generator
      attr_reader :verification_code

      EXPIRATION_TIME = 5.minutes
      VERIFICATION_CODE_EMAIL_TEMPLATE = 'd-8dfeebf382ed485fac8c67bb35617c2d'.freeze

      def initialize(user:, channel:)
        self.user = user
        self.channel = channel || VerificationCode::DEFAULT_CHANNEL
      end

      def call
        validate_channel

        create_code
        schedule_expiration

        send_code
      end

      private

      attr_accessor :user, :raw_code, :channel, :generator
      attr_writer :verification_code

      def validate_channel
        raise InvalidChannel, channel if VerificationCode::CHANNELS.none?(channel)
      end

      def create_code
        self.raw_code = generate_raw_code
        self.verification_code = VerificationCode.create!(
          user: user,
          code: raw_code,
          channel: channel,
          expires_at: EXPIRATION_TIME.from_now,
          status: VerificationCode::STARTED
        )
      rescue ActiveRecord::RecordInvalid => e
        raise InvalidCode, [e.message]
      end

      def generate_raw_code
        return if channel == VerificationCode::SMS_CHANNEL # Twilio will generate the code on its own

        format('%06d', rand(0..999_999))
      end

      def schedule_expiration
        ExpirationScheduler.new(
          verification_code: verification_code,
          wait_time: EXPIRATION_TIME
        ).call
      end

      def send_code
        if channel == VerificationCode::SMS_CHANNEL
          send_twilio_code
        else
          send_email
        end
      end

      def send_twilio_code
        Communications::TwilioVerificationSenderJob.perform_later(
          target: user,
          channel: 'sms'
        )
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
