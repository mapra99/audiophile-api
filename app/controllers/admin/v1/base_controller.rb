module Admin
  module V1
    class BaseController < Admin::BaseController
      before_action :validate_api_key!

      private

      def validate_api_key!
        admin_key_header = request.headers['X-ADMIN-KEY']
        admin_token = ENV.fetch('X_ADMIN_KEY')

        head :unauthorized if admin_key_header != admin_token
      end
    end
  end
end
