module Api
  module V1
    class PurchaseCartsController < BaseController
      skip_before_action :authenticate_user_by_token!

      PURCHASE_CART_ERROR_CODES = {
        cart_not_found: 404,
        invalid_status: 422,
        stock_not_found: 400,
        insufficient_stock: 422,
        invalid_cart_item: 422,
        invalid_extra_fee: 422
      }.freeze

      PURCHASE_CART_ERROR_MESSAGES = {}.freeze

      def create
        creator = Api::V1::PurchaseCarts::Creator.new(params: purchase_cart_params)
        result = creator.call
        return render_error_from(result) if result.failure?

        @purchase_cart = result.value!
      end

      def destroy
        destroyer = Api::V1::PurchaseCarts::Destroyer.new(cart_uuid: params[:uuid])
        result = destroyer.call
        return render_error_from(result) if result.failure?
      end

      def show
        finder = Api::V1::PurchaseCarts::Finder.new(cart_uuid: params[:uuid])
        result = finder.call
        return render_error_from(result) if result.failure?

        @purchase_cart = result.value!
      end

      private

      def purchase_cart_params
        params.permit(items: %i[quantity stock_uuid])
      end

      def error_status_code(error)
        cart_error_code = PURCHASE_CART_ERROR_CODES[error[:code]]
        return cart_error_code if cart_error_code.present?

        super(error)
      end

      def error_message(error)
        cart_error_message = PURCHASE_CART_ERROR_MESSAGES[error[:code]] || ''
        cart_error_message += error[:message] if error[:message].present?
        return cart_error_message if cart_error_message.present?

        super(error)
      end
    end
  end
end
