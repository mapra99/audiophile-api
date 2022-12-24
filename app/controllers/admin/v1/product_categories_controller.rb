module Admin
  module V1
    class ProductCategoriesController < BaseController
      PRODUCT_CATEGORY_ERROR_CODES = {
        product_category_not_saved: 500,
        invalid_product_category: 422,
        category_not_found: 400
      }.freeze

      PRODUCT_CATEGORY_ERROR_MESSAGES = {
        product_category_not_saved: 'Could not save product',
        invalid_product_category: 'Product is invalid: ',
        category_not_found: 'Could not find product category'
      }.freeze

      def create
        creator = Admin::V1::ProductCategories::Creator.new(params: product_category_params)
        result = creator.call
        return render_error_from(result) if result.failure?

        @product_category = result.value!
      end

      def index
        collection_builder = Admin::V1::ProductCategories::CollectionBuilder.new
        result = collection_builder.call(filters: filter_params)
        return render_error_from(result) if result.failure?

        @product_categories = result.value!
      end

      def update
        updater = Admin::V1::ProductCategories::Updater.new(category_id: params[:id], params: product_category_params)
        result = updater.call
        return render_error_from(result) if result.failure?

        @product_category = result.value!
      end

      private

      def filter_params
        params.permit(:name)
      end

      def product_category_params
        params.permit(:name, :image)
      end

      def error_status_code(error)
        category_error_code = PRODUCT_CATEGORY_ERROR_CODES[error[:code]]
        return category_error_code if category_error_code.present?

        super(error)
      end

      def error_message(error)
        caegory_error_message = PRODUCT_CATEGORY_ERROR_MESSAGES[error[:code]]
        caegory_error_message += error[:message].join(', ') if error[:code] == :invalid_product_category
        return caegory_error_message if caegory_error_message.present?

        super(error)
      end
    end
  end
end
