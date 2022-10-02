class HealthController < ApplicationController
  def show
    render json: { health: 'ok' }, status: :ok
  end
end
