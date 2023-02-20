module Authentication
  module VerificationCodes
    module Email
      class CodeSender
        VERIFICATION_CODE_EMAIL_TEMPLATE = 'd-8dfeebf382ed485fac8c67bb35617c2d'.freeze

        def initialize(user:, raw_code:)
          self.user = user
          self.raw_code = raw_code
        end

        def call
          Communications::EmailSenderJob.perform_later(
            topic: Communication::VERIFICATION_CODE_TOPIC,
            sender: EmailCommunication::AUTH_SENDER_EMAIL,
            recipient: user.email,
            template_id: VERIFICATION_CODE_EMAIL_TEMPLATE,
            template_data: {
              user_name: user.name,
              verification_code: raw_code
            },
            target: user
          )
        end

        private

        attr_accessor :user, :raw_code
      end
    end
  end
end
