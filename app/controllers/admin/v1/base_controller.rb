module Admin
  module V1
    class BaseController < Admin::BaseController
      before_action :authenticate_by_token!

      private

      def authenticate_by_token!
        admin_key_header = request.headers['X-ADMIN-KEY']
        admin_token = ENV.fetch('X_ADMIN_KEY')

        head :unauthorized if admin_key_header != admin_token
      end
    end
  end
end
