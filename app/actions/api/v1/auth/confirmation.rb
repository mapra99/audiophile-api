module Api
  module V1
    module Auth
      class Confirmation
        include Dry::Monads[:result]

        attr_reader :access_token

        def initialize(params:, session:)
          self.params = params
          self.session = session
        end

        def call
          find_user
          check_code
          create_token
          update_session

          Success(access_token)
        rescue ServiceError => e
          e.failure
        rescue StandardError => e
          Rails.logger.error(e)
          Failure({ code: :internal_error })
        end

        private

        attr_accessor :params, :user, :verification_code, :session
        attr_writer :access_token

        def find_user
          self.user = User.find_by(email: params[:email])
          return if user.present?

          raise ServiceError, Failure({ code: :user_not_found, message: "User email '#{params[:email]}' not found" })
        end

        def check_code
          code_checker = Authentication::VerificationCodes::Checker.new(user: user, code: params[:code])
          code_checker.call

          self.verification_code = code_checker.verification_code
        rescue Authentication::VerificationCodes::NoStartedCodes => e
          raise ServiceError, Failure({ code: :no_started_codes, message: e.message })
        rescue Authentication::VerificationCodes::IncorrectCode => e
          raise ServiceError, Failure({ code: :incorrect_code, message: e.message })
        end

        def create_token
          token_generator = Authentication::AccessTokens::Generator.new(
            user: user,
            verification_code: verification_code
          )

          token_generator.call
          self.access_token = token_generator.access_token
        rescue Authentication::AccessTokens::InvalidToken => e
          raise ServiceError, Failure({ code: :invalid_token, message: e.message })
        end

        def update_session
          session.update!(user: user)
        end
      end
    end
  end
end
