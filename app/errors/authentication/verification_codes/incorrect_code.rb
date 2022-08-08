module Authentication
  module VerificationCodes
    class IncorrectCode < StandardError
      attr_reader :user_id, :code

      def initialize(user_id, code)
        @user_id = user_id
        @code = code
        message = "Code #{code} is incorrect for user ID #{user_id}"

        super(message)
      end
    end
  end
end
