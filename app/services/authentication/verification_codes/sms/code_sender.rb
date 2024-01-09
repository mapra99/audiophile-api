module Authentication
  module VerificationCodes
    module Sms
      class CodeSender
        def initialize(user:, raw_code:)
          self.user = user
          self.raw_code = raw_code
        end

        def call
          Communications::TwilioVerificationSenderJob.perform_later(
            target: user,
            channel: 'sms'
          )
        end

        private

        attr_accessor :user, :raw_code
      end
    end
  end
end
