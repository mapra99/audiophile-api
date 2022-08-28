module Api
  module V1
    class LocationsController < BaseController
      LOCATION_ERROR_CODES = {
        invalid_location: 422
      }.freeze
      LOCATION_ERROR_MESSAGES = {}.freeze

      def create
        creator = Api::V1::Locations::Creator.new(
          params: location_params,
          user: current_user
        )
        result = creator.call
        return render_error_from(result) if result.failure?

        @user_location = result.value!
      end

      private

      def location_params
        params.permit(:street_address, :city, :country, :postal_code, :extra_info)
      end

      def error_status_code(error)
        cart_error_code = LOCATION_ERROR_CODES[error[:code]]
        return cart_error_code if cart_error_code.present?

        super(error)
      end

      def error_message(error)
        cart_error_message = LOCATION_ERROR_MESSAGES[error[:code]] || ''
        cart_error_message += error[:message] if error[:message].present?
        return cart_error_message if cart_error_message.present?

        super(error)
      end
    end
  end
end
