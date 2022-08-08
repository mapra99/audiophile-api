module Authentication
  module VerificationCodes
    class InvalidCode < StandardError
      attr_reader :code_errors

      def initialize(code_errors)
        @code_errors = code_errors
        message = code_errors.join(', ')

        super(message)
      end
    end
  end
end
