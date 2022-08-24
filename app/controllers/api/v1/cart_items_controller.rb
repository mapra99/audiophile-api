module Api
  module V1
    class CartItemsController < BaseController
      skip_before_action :authenticate_user_by_token!
      before_action :authenticate_session_by_header!

      PURCHASE_CART_ITEM_ERROR_CODES = {
        cart_not_found: 404,
        stock_not_found: 400,
        insufficient_stock: 422,
        invalid_cart_item: 422,
        cart_item_not_found: 404
      }.freeze

      PURCHASE_CART_ITEM_ERROR_MESSAGES = {}.freeze

      def create
        creator = Api::V1::CartItems::Creator.new(
          cart_uuid: params[:purchase_cart_uuid],
          item_params: purchase_cart_item_params,
          session: current_session
        )
        result = creator.call
        return render_error_from(result) if result.failure?

        @purchase_cart_item = result.value!
      end

      def destroy
        destroyer = Api::V1::CartItems::Destroyer.new(item_uuid: params[:uuid], session: current_session)
        result = destroyer.call
        return render_error_from(result) if result.failure?
      end

      private

      def purchase_cart_item_params
        params.permit(:quantity, :stock_uuid)
      end

      def error_status_code(error)
        cart_error_code = PURCHASE_CART_ITEM_ERROR_CODES[error[:code]]
        return cart_error_code if cart_error_code.present?

        super(error)
      end

      def error_message(error)
        cart_error_message = PURCHASE_CART_ITEM_ERROR_MESSAGES[error[:code]] || ''
        cart_error_message += error[:message] if error[:message].present?
        return cart_error_message if cart_error_message.present?

        super(error)
      end
    end
  end
end
