module Payments
  class FailureDispatch
    def initialize(payment:)
      self.payment = payment
    end

    def call
      ActiveRecord::Base.transaction do
        update_payment_status
      end
    end

    private

    attr_accessor :payment

    def update_payment_status
      payment.update!(status: Payment::CANCELED)
    end
  end
end
