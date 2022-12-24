module Admin
  module V1
    class ProductContentsController < BaseController
      PRODUCT_CONTENT_ERROR_CODES = {
        product_content_not_saved: 500,
        invalid_product_content: 422,
        product_not_found: 400,
        product_content_not_found: 400
      }.freeze

      PRODUCT_CONTENT_ERROR_MESSAGES = {
        product_content_not_saved: 'Could not save product',
        invalid_product_content: 'Content is invalid: ',
        product_not_found: 'Could not find product',
        product_content_not_found: 'Could not find product content'
      }.freeze

      def create
        creator = Admin::V1::ProductContents::Creator.new(params: product_content_params)
        result = creator.call
        return render_error_from(result) if result.failure?

        @product_content = result.value!
      end

      def update
        updater = Admin::V1::ProductContents::Updater.new(params: product_content_params)
        result = updater.call
        return render_error_from(result) if result.failure?

        @product_content = result.value!
      end

      private

      def product_content_params
        params.permit(:product_id, :key, :content, content: [])
      end

      def error_status_code(error)
        content_error_code = PRODUCT_CONTENT_ERROR_CODES[error[:code]]
        return content_error_code if content_error_code.present?

        super(error)
      end

      def error_message(error)
        content_error_message = PRODUCT_CONTENT_ERROR_MESSAGES[error[:code]]
        content_error_message += error[:message].join(', ') if error[:code] == :invalid_product_content
        return content_error_message if content_error_message.present?

        super(error)
      end
    end
  end
end
