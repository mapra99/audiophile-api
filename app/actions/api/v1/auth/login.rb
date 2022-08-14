module Api
  module V1
    module Auth
      class Login
        include Dry::Monads[:result]

        def initialize(email:)
          self.email = email
        end

        def call
          find_user
          generate_code

          Success(nil)
        rescue ServiceError => e
          e.failure
        rescue StandardError => e
          Rails.logger.error(e)
          Failure({ code: :internal_error })
        end

        private

        attr_accessor :email, :user, :verification_code

        def find_user
          self.user = User.find_by(email: email)
          return if user.present?

          raise ServiceError, Failure({ code: :user_not_found, message: "User with email '#{email}' not found" })
        end

        def generate_code
          generator = Authentication::VerificationCodes::Generator.new(user: user)
          generator.call

          self.verification_code = generator.verification_code
        rescue Authentication::VerificationCodes::InvalidCode => e
          Rails.logger.error(e)
          raise ServiceError, Failure({ code: :code_not_created, message: e.message })
        end
      end
    end
  end
end
