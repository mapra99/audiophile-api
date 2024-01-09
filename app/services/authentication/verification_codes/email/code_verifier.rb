module Authentication
  module VerificationCodes
    module Email
      class CodeVerifier
        def initialize(verification_code:, raw_code:)
          self.verification_code = verification_code
          self.raw_code = raw_code
        end

        def call
          valid = verification_code.authenticate_code(raw_code)
          raise IncorrectCode.new(verification_code.user.id, raw_code) unless valid
        end

        private

        attr_accessor :verification_code, :raw_code
      end
    end
  end
end
