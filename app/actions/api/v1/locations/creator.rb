module Api
  module V1
    module Locations
      class Creator
        include Dry::Monads[:result]

        attr_reader :user_location

        def initialize(params:, user:)
          self.params = params
          self.user = user
        end

        def call
          create_location
          create_user_location

          Success(user_location)
        rescue ServiceError => e
          e.failure
        rescue StandardError => e
          Rails.logger.error(e)
          Failure({ code: :internal_error })
        end

        private

        attr_accessor :params, :user, :location
        attr_writer :user_location

        def create_location
          location_creator.call
          self.location = location_creator.location
        rescue ::Locations::InvalidLocation => e
          Rails.logger.error(e)
          raise ServiceError, Failure({ code: :invalid_location, message: e.message })
        end

        def create_user_location
          self.user_location = UserLocation.find_or_create_by!(
            user: user,
            location: location,
            extra_info: params[:extra_info]
          )
        rescue ActiveRecord::RecordInvalid => e
          Rails.logger.error(e)
          raise ServiceError, Failure({ code: :invalid_location, message: e.message })
        end

        def location_creator
          @location_creator ||= ::Locations::LocationCreator.new(
            street_address: params[:street_address],
            city: params[:city],
            country: params[:country],
            postal_code: params[:postal_code]
          )
        end
      end
    end
  end
end
