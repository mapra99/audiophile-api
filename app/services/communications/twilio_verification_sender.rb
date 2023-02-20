module Communications
  class TwilioVerificationSender
    TWILIO_ACCOUNT_SID = ENV.fetch('TWILIO_ACCOUNT_SID', '')
    TWILIO_AUTH_TOKEN = ENV.fetch('TWILIO_AUTH_TOKEN', '')
    TWILIO_VERIFY_SERVICE_SID = ENV.fetch('TWILIO_VERIFY_SERVICE_SID', '')

    E_164_REGEXP = /[+\d]/

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
      verification = twilio_client.verify
                                  .v2
                                  .services(TWILIO_VERIFY_SERVICE_SID)
                                  .verifications
                                  .create(to: e_164_target_phone, channel: channel)

      self.verification = verification
    end

    def create_communication
      self.communication = Communication.create!(
        topic: Communication::VERIFICATION_CODE_TOPIC
      )
    end

    def create_twilio_communication
      self.twilio_verify_communication = TwilioVerifyCommunication.create!(
        recipient: e_164_target_phone,
        verification_sid: verification.sid,
        channel: verification.channel,
        service_sid: verification.service_sid,
        communication: communication,
        target: target
      )
    end

    def e_164_target_phone
      target.phone.scan(E_164_REGEXP).join
    end

    def twilio_client
      @twilio_client ||= Twilio::REST::Client.new(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN)
    end
  end
end
