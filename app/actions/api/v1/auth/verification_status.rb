module Api
  module V1
    module Auth
      class VerificationStatus
        include Dry::Monads[:result]

        def initialize(email:)
          self.email = email
        end

        def call
          self.user = find_user
          self.verification_code = find_verification_code

          Success(verification_code)
        rescue ServiceError => e
          e.failure
        rescue StandardError => e
          Rails.logger.error(e)
          Failure({ code: :internal_error })
        end

        private

        attr_accessor :email, :user, :verification_code

        def find_user
          User.find_by!(email: email)
        rescue ActiveRecord::RecordNotFound
          raise ServiceError, Failure({ code: :user_not_found, message: "User with email '#{email}' not found" })
        end

        def find_verification_code
          user.verification_codes.started.last
        end
      end
    end
  end
end
