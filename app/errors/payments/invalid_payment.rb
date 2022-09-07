module Payments
  class InvalidPayment < StandardError
    attr_reader :payment_errors

    def initialize(payment_errors)
      @payment_errors = payment_errors
      message = payment_errors.join(', ')

      super(message)
    end
  end
end
