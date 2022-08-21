module Api
  module V1
    class SessionsController < BaseController
      skip_before_action :authenticate_user_by_token!

      SESSION_ERROR_CODES = {
        invalid_session: 422
      }.freeze
      SESSION_ERROR_MESSAGES = {}.freeze

      def create
        creator = Api::V1::Sessions::Creator.new(client_ip: client_ip)
        result = creator.call
        return render_error_from(result) if result.failure?

        @session = result.value!
      end

      private

      def client_ip
        request.remote_ip
      end

      def error_status_code(error)
        cart_error_code = SESSION_ERROR_CODES[error[:code]]
        return cart_error_code if cart_error_code.present?

        super(error)
      end

      def error_message(error)
        cart_error_message = SESSION_ERROR_MESSAGES[error[:code]] || ''
        cart_error_message += error[:message] if error[:message].present?
        return cart_error_message if cart_error_message.present?

        super(error)
      end
    end
  end
end
