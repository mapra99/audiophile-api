module Authentication
  module AccessTokens
    class RevokerJob < ApplicationJob
      queue_as :default

      def perform(access_token_id)
        Authentication::AccessTokens::Revoker.new(access_token_id: access_token_id).call
      end
    end
  end
end
