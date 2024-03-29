module Admin
  module V1
    class ProductsController < BaseController
      PRODUCT_ERROR_CODES = {
        product_not_found: 400,
        category_not_found: 400,
        product_not_saved: 500,
        invalid_product: 422
      }.freeze

      PRODUCT_ERROR_MESSAGES = {
        product_not_found: 'Could not find product',
        category_not_found: 'Could not find product category',
        product_not_saved: 'Could not save product',
        invalid_product: 'Product is invalid: '
      }.freeze

      def index
        collection_builder = Admin::V1::Products::CollectionBuilder.new
        result = collection_builder.call(filters: filter_params)
        return render_error_from(result) if result.failure?

        @products = result.value!
      end

      def create
        creator = Admin::V1::Products::Creator.new(params: product_params)
        result = creator.call
        return render_error_from(result) if result.failure?

        @product = result.value!
      end

      def show
        finder = Admin::V1::Products::Finder.new(product_id: params[:id])
        result = finder.call
        return render_error_from(result) if result.failure?

        @product = result.value!
      end

      def update
        updater = Admin::V1::Products::Updater.new(product_id: params[:id], params: product_params)
        result = updater.call
        return render_error_from(result) if result.failure?

        @product = result.value!
      end

      private

      def filter_params
        params.permit(:featured, :categories)
      end

      def product_params
        params.permit(:name, :price, :featured, :category_id, :image)
      end

      def error_status_code(error)
        product_error_code = PRODUCT_ERROR_CODES[error[:code]]
        return product_error_code if product_error_code.present?

        super(error)
      end

      def error_message(error)
        product_error_message = PRODUCT_ERROR_MESSAGES[error[:code]]
        product_error_message += error[:message].join(', ') if error[:code] == :invalid_product
        return product_error_message if product_error_message.present?

        super(error)
      end
    end
  end
end
