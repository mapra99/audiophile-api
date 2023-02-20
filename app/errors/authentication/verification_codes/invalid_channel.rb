module Authentication
  module VerificationCodes
    class InvalidChannel < StandardError
      def initialize(channel)
        message = "Code channel #{channel} is invalid. Must be one of #{VerificationCode::CHANNELS}"

        super(message)
      end
    end
  end
end
