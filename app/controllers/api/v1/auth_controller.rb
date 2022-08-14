module Api
  module V1
    class AuthController < BaseController
      skip_before_action :authenticate_user_by_token!, only: %i[signup login confirmation]

      AUTH_ERROR_CODES = {
        invalid_user: 422,
        code_not_created: 422,
        no_started_codes: 422,
        invalid_token: 422,
        user_not_found: 400,
        incorrect_code: 400
      }.freeze
      AUTH_ERROR_MESSAGES = {}.freeze

      def signup
        signup_action = Api::V1::Auth::Signup.new(params: user_params)
        result = signup_action.call
        return render_error_from(result) if result.failure?
      end

      def login
        login_action = Api::V1::Auth::Login.new(email: params[:email])
        result = login_action.call
        return render_error_from(result) if result.failure?
      end

      def confirmation
        confirmation_action = Api::V1::Auth::Confirmation.new(params: confirmation_params)
        result = confirmation_action.call
        return render_error_from(result) if result.failure?

        @access_token = result.value!
      end

      def logout
        logout_action = Api::V1::Auth::Logout.new(user: current_user, access_token: access_token)
        result = logout_action.call
        return render_error_from(result) if result.failure?
      end

      private

      def user_params
        params.permit(:name, :email, :phone)
      end

      def confirmation_params
        params.permit(:email, :code)
      end

      def error_status_code(error)
        cart_error_code = AUTH_ERROR_CODES[error[:code]]
        return cart_error_code if cart_error_code.present?

        super(error)
      end

      def error_message(error)
        cart_error_message = AUTH_ERROR_MESSAGES[error[:code]] || ''
        cart_error_message += error[:message] if error[:message].present?
        return cart_error_message if cart_error_message.present?

        super(error)
      end
    end
  end
end
