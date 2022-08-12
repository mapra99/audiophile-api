module Authentication
  module VerificationCodes
    class Revoker
      attr_reader :verification_code

      def initialize(verification_code_id:)
        self.verification_code_id = verification_code_id
      end

      def call
        find_verification_code
        update_status
      end

      private

      attr_accessor :verification_code_id
      attr_writer :verification_code

      def find_verification_code
        self.verification_code = VerificationCode.find(verification_code_id)
      end

      def update_status
        verification_code.update!(status: VerificationCode::EXPIRED)
      end
    end
  end
end
