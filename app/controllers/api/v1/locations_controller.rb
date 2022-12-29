module Api
  module V1
    class LocationsController < BaseController
      LOCATION_ERROR_CODES = {
        invalid_location: 422,
        location_not_found: 400
      }.freeze
      LOCATION_ERROR_MESSAGES = {
        location_not_found: 'Could not find location'
      }.freeze

      def index
        collection_builder = Api::V1::Locations::CollectionBuilder.new(user: current_user)
        result = collection_builder.call
        return render_error_from(result) if result.failure?

        @user_locations = result.value!
      end

      def create
        creator = Api::V1::Locations::Creator.new(
          params: location_params,
          user: current_user
        )
        result = creator.call
        return render_error_from(result) if result.failure?

        @user_location = result.value!
      end

      def show
        finder = Api::V1::Locations::Finder.new(
          user_location_uuid: params[:uuid],
          user: current_user
        )

        result = finder.call
        return render_error_from(result) if result.failure?

        @user_location = result.value!
      end

      def destroy
        destroyer = Api::V1::Locations::Destroyer.new(
          user_location_uuid: params[:uuid],
          user: current_user
        )

        result = destroyer.call
        return render_error_from(result) if result.failure?
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
