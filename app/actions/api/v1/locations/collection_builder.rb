module Api
  module V1
    module Locations
      class CollectionBuilder
        include Dry::Monads[:result]

        attr_reader :user_locations

        def initialize(user:)
          self.user = user
        end

        def call
          fetch_locations

          Success(user_locations)
        rescue ServiceError => e
          e.failure
        rescue StandardError => e
          Rails.logger.error(e)
          Failure({ code: :internal_error })
        end

        private

        attr_accessor :user
        attr_writer :user_locations

        def fetch_locations
          self.user_locations = user.user_locations
        end
      end
    end
  end
end
