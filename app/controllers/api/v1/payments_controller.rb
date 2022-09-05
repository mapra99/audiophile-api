module Api
  module V1
    class PaymentsController < BaseController
      PAYMENT_ERROR_CODES = {
        invalid_payment: 422,
        provider_error: 500,
        purchase_cart_not_found: 400,
        invalid_purchase_cart: 400
      }.freeze
      PAYMENT_ERROR_MESSAGES = {}.freeze

      def create
        creator = Api::V1::Payments::Creator.new(
          purchase_cart_uuid: params[:purchase_cart_uuid],
          user: current_user
        )
        result = creator.call
        return render_error_from(result) if result.failure?

        @payment_intent = creator.payment_intent
        @payment = creator.payment
      end

      private

      def error_status_code(error)
        cart_error_code = PAYMENT_ERROR_CODES[error[:code]]
        return cart_error_code if cart_error_code.present?

        super(error)
      end

      def error_message(error)
        cart_error_message = PAYMENT_ERROR_MESSAGES[error[:code]] || ''
        cart_error_message += error[:message] if error[:message].present?
        return cart_error_message if cart_error_message.present?

        super(error)
      end
    end
  end
end
