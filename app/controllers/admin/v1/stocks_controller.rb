module Admin
  module V1
    class StocksController < BaseController
      STOCK_ERROR_CODES = {
        product_not_found: 400,
        stock_not_saved: 500,
        invalid_stock: 422,
        invalid_toppings: 422
      }.freeze

      STOCK_ERROR_MESSAGES = {
        product_not_found: 'Could not find product',
        stock_not_saved: 'Could not save stock',
        invalid_stock: 'Stock is invalid: ',
        invalid_toppings: 'Toppings are invalid: '
      }.freeze

      def index
        collection_builder = Admin::V1::Stocks::CollectionBuilder.new
        result = collection_builder.call(filters: filter_params)
        return render_error_from(result) if result.failure?

        @stocks = result.value!
      end

      def create
        creator = Admin::V1::Stocks::Creator.new(params: stock_params)
        result = creator.call
        return render_error_from(result) if result.failure?

        @stock = result.value!
      end

      private

      def filter_params
        params.permit(:product_id)
      end

      def stock_params
        params.permit(:product_id, :quantity, toppings: %i[key value price_change])
      end

      def error_status_code(error)
        stock_error_code = STOCK_ERROR_CODES[error[:code]]
        return stock_error_code if stock_error_code.present?

        super(error)
      end

      def error_message(error)
        stock_error_message = STOCK_ERROR_MESSAGES[error[:code]]
        stock_error_message += error[:message].join(', ') if error[:message].present?
        return stock_error_message if stock_error_message.present?

        super(error)
      end
    end
  end
end
