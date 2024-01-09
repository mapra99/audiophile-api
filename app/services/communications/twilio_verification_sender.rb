module Communications
  class TwilioVerificationSender
    attr_reader :communication, :twilio_verify_communication

    TEST_RECIPIENT = ENV.fetch('TEST_PHONES_RECIPIENT', '+1 209 885 7159')

    def initialize(target:, channel:)
      self.target = target
      self.channel = channel
    end

    def call
      resolve_recipient
      send_code

      create_communication
      create_twilio_communication
    end

    private

    attr_accessor :target, :channel, :verification, :recipient
    attr_writer :communication, :twilio_verify_communication

    def resolve_recipient
      prod_or_stg = Rails.env.production? || Rails.env.staging?
      self.recipient = prod_or_stg ? target.phone : TEST_RECIPIENT
    end

    def send_code
      verification = Interfaces::TwilioInterface.send_verification_token(
        phone: recipient,
        channel: channel
      )

      self.verification = verification
    end

    def create_communication
      self.communication = Communication.create!(
        topic: Communication::VERIFICATION_CODE_TOPIC
      )
    end

    def create_twilio_communication
      self.twilio_verify_communication = TwilioVerifyCommunication.create!(
        recipient: Interfaces::TwilioInterface.e_164_format(recipient),
        verification_sid: verification.sid,
        channel: verification.channel,
        service_sid: verification.service_sid,
        communication: communication,
        target: target
      )
    end
  end
end
