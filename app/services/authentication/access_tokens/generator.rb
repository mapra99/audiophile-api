module Authentication
  module AccessTokens
    class Generator
      attr_reader :access_token

      EXPIRATION_TIME = 1.week

      def initialize(user:, verification_code:)
        self.user = user
        self.verification_code = verification_code
      end

      def call
        create_token
        schedule_expiration
      end

      private

      attr_accessor :user, :verification_code
      attr_writer :token, :access_token

      def create_token
        self.access_token = user.access_tokens.create(
          verification_code: verification_code,
          token: SecureRandom.hex,
          status: AccessToken::ACTIVE,
          expires_at: EXPIRATION_TIME.from_now
        )
      rescue ActiveRecord::RecordInvalid => e
        raise InvalidToken, [e.message]
      end

      def schedule_expiration
        ExpirationScheduler.new(
          access_token: access_token,
          wait_time: EXPIRATION_TIME
        ).call
      end
    end
  end
end
