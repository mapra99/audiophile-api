module Authentication
  module VerificationCodes
    class RevokerJob < ApplicationJob
      queue_as :default

      def perform(verification_code_id)
        Authentication::VerificationCodes::Revoker.new(verification_code_id: verification_code_id).call
      end
    end
  end
end
