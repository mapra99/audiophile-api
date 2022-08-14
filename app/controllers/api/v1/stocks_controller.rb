module Api
  module V1
    class StocksController < BaseController
      skip_before_action :authenticate_user_by_token!

      STOCK_ERROR_CODES = {
        product_not_found: 400,
        topping_not_found: 400
      }.freeze

      STOCK_ERROR_MESSAGES = {
        product_not_found: 'Could not find product',
        topping_not_found: 'Topping not found:'
      }.freeze

      def index
        collection_builder = Api::V1::Stocks::CollectionBuilder.new
        result = collection_builder.call(product_slug: params[:product_slug], toppings_filters: toppings_params)
        return render_error_from(result) if result.failure?

        @stocks = result.value!
      end

      private

      def toppings_params
        topping_keys = product.present? ? product.toppings.pluck(:key).uniq.map(&:to_sym) : []
        params.permit(*topping_keys)
      end

      def product
        @product ||= Product.find_by(slug: params[:product_slug])
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
