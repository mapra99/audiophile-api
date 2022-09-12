module Payments
  class SuccessDispatch
    def initialize(payment:)
      self.payment = payment
    end

    def call
      ActiveRecord::Base.Transaction do
        update_payment_status
        update_cart_status
        start_order
      end
    end

    private

    attr_accessor :payment

    def update_payment_status
      payment.update!(status: Payment::COMPLETED)
    end

    def update_cart_status
      payment.purchase_cart.update!(status: PurchaseCart::PAID)
    end

    def start_order
      Orders::StartOrder.new(payment: payment).call
    end
  end
end
