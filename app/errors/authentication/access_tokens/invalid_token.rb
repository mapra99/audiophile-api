module Authentication
  module AccessTokens
    class InvalidToken < StandardError
      attr_reader :token_errors

      def initialize(token_errors)
        @token_errors = token_errors
        message = token_errors.join(', ')

        super(message)
      end
    end
  end
end
