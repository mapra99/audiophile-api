module Api
  module V1
    class BaseController < Api::BaseController
      include TokenAuth
      include SessionAuth

      before_action :validate_api_key!

      private

      def validate_api_key!
        admin_key_header = request.headers['X-AUDIOPHILE-KEY']
        admin_token = ENV.fetch('X_AUDIOPHILE_KEY')

        head :unauthorized if admin_key_header != admin_token
      end
    end
  end
end
