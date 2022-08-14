module Authentication
  module AccessTokens
    class Revoker
      attr_reader :access_token

      def initialize(access_token_id:)
        self.access_token_id = access_token_id
      end

      def call
        find_access_token
        update_status
      end

      private

      attr_accessor :access_token_id
      attr_writer :access_token

      def find_access_token
        self.access_token = AccessToken.find(access_token_id)
      end

      def update_status
        access_token.update!(status: AccessToken::EXPIRED)
      end
    end
  end
end
