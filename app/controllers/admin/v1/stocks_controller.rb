module Admin
  module V1
    class StocksController < BaseController
      PRODUCT_ERROR_CODES = {
        product_not_found: 400,
        stock_not_saved: 500,
        invalid_stock: 422,
        invalid_toppings: 422
      }.freeze

      PRODUCT_ERROR_MESSAGES = {
        product_not_found: 'Could not find product',
        stock_not_saved: 'Could not save stock',
        invalid_stock: 'Stock is invalid: ',
        invalid_toppings: 'Toppings are invalid: '
      }.freeze

      def create
        creator = Admin::V1::Stocks::Creator.new(params: stock_params)
        result = creator.call
        return render_error_from(result) if result.failure?

        @stock = result.value!
      end

      private

      def stock_params
        params.permit(:product_id, :quantity, toppings: %i[key value price_change])
      end

      def error_status_code(error)
        product_error_code = PRODUCT_ERROR_CODES[error[:code]]
        return product_error_code if product_error_code.present?

        super(error)
      end

      def error_message(error)
        product_error_message = PRODUCT_ERROR_MESSAGES[error[:code]]
        product_error_message += error[:message].join(', ') if error[:message].present?
        return product_error_message if product_error_message.present?

        super(error)
      end
    end
  end
end
