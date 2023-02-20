module Communications
  class TwilioVerificationSender
    attr_reader :communication, :twilio_verify_communication

    def initialize(target:, channel:)
      self.target = target
      self.channel = channel
    end

    def call
      send_code

      create_communication
      create_twilio_communication
    end

    private

    attr_accessor :target, :channel, :verification
    attr_writer :communication, :twilio_verify_communication

    def send_code
      verification = Interfaces::TwilioInterface.send_verification_token(
        phone: target.phone,
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
        recipient: Interfaces::TwilioInterface.e_164_format(target.phone),
        verification_sid: verification.sid,
        channel: verification.channel,
        service_sid: verification.service_sid,
        communication: communication,
        target: target
      )
    end
  end
end
