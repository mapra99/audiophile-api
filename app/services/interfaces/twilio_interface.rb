module Interfaces
  class TwilioInterface
    class << self
      TWILIO_ACCOUNT_SID = ENV.fetch('TWILIO_ACCOUNT_SID', '')
      TWILIO_AUTH_TOKEN = ENV.fetch('TWILIO_AUTH_TOKEN', '')
      TWILIO_VERIFY_SERVICE_SID = ENV.fetch('TWILIO_VERIFY_SERVICE_SID', '')

      E_164_REGEXP = /[+\d]/

      def send_verification_token(phone:, channel:)
        client.verify
              .v2
              .services(TWILIO_VERIFY_SERVICE_SID)
              .verifications
              .create(to: e_164_format(phone), channel: channel)
      end

      def check_verification_token(phone:, code:)
        client.verify
              .v2
              .services(TWILIO_VERIFY_SERVICE_SID)
              .verification_checks
              .create(to: e_164_format(phone), code: code)
      end

      def e_164_format(phone)
        phone.scan(E_164_REGEXP).join
      end

      private

      def client
        @client ||= Twilio::REST::Client.new(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN)
      end
    end
  end
end