module Payments
  class FailureDispatch
    def initialize(payment:)
      self.payment = payment
    end

    def call
      ActiveRecord::Base.transaction do
        update_payment_status
        send_failure_email
      end
    end

    private

    attr_accessor :payment

    def update_payment_status
      payment.update!(status: Payment::CANCELED)
    end

    def send_failure_email
      Payments::FailureEmailSender.new(payment: payment).call
    end
  end
end
