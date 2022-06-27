module Admin
  module V1
    class HealthController < Admin::BaseController
      def show
        render json: { health: 'ok' }, status: :ok
      end
    end
  end
end
