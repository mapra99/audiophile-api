module Authentication
  module VerificationCodes
    module Sms
      class CodeVerifier
        APPROVED_STATUS = 'approved'.freeze

        def initialize(verification_code:, raw_code:)
          self.verification_code = verification_code
          self.raw_code = raw_code
        end

        def call
          verification_check = Interfaces::TwilioInterface.check_verification_token(
            phone: verification_code.user.phone,
            code: raw_code
          )

          raise IncorrectCode.new(verification_code.user.id, raw_code) if verification_check.status != APPROVED_STATUS
        end

        private

        attr_accessor :verification_code, :raw_code

        def e_164_user_phone
          verification_code.user.phone.scan(E_164_REGEXP).join
        end
      end
    end
  end
end
