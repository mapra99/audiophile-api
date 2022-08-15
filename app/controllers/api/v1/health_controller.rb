module Api
  module V1
    class HealthController < BaseController
      skip_before_action :authenticate_user_by_token!

      def show
        render json: { health: 'ok' }, status: :ok
      end
    end
  end
end
