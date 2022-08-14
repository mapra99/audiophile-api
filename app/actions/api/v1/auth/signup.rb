module Api
  module V1
    module Auth
      class Signup
        include Dry::Monads[:result]

        def initialize(params:)
          self.params = params
        end

        def call
          create_user
          generate_code

          Success(nil)
        rescue ServiceError => e
          e.failure
        rescue StandardError => e
          Rails.logger.error(e)
          Failure({ code: :internal_error })
        end

        private

        attr_accessor :params, :user, :verification_code

        def create_user
          self.user = User.create!(
            name: params[:name],
            email: params[:email],
            phone: params[:phone]
          )
        rescue ActiveRecord::RecordInvalid => e
          Rails.logger.error(e)
          raise ServiceError, Failure({ code: :invalid_user, message: e.message })
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
