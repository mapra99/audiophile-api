module Authentication
  module VerificationCodes
    class NoStartedCodes < StandardError
      attr_reader :user_id

      def initialize(user_id)
        @user_id = user_id
        message = "User ID #{user_id} has no verification code with started status"

        super(message)
      end
    end
  end
end
