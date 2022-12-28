module Api
  module V1
    module Locations
      class Destroyer
        include Dry::Monads[:result]

        def initialize(user_location_uuid:, user:)
          self.user_location_uuid = user_location_uuid
          self.user = user
        end

        def call
          self.user_location = find_user_location
          user_location.destroy!

          Success(true)
        rescue ServiceError => e
          e.failure
        rescue StandardError => e
          Rails.logger.error(e)
          Failure({ code: :internal_error })
        end

        private

        attr_accessor :user_location_uuid, :user, :user_location

        def find_user_location
          self.user_location = user.user_locations.find_by!(uuid: user_location_uuid)
        rescue ActiveRecord::RecordNotFound => e
          Rails.logger.error(e)
          raise ServiceError, Failure({ code: :location_not_found })
        end
      end
    end
  end
end
