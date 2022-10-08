module Payments
  class SuccessDispatch
    def initialize(payment:)
      self.payment = payment
    end

    def call
      ActiveRecord::Base.transaction do
        update_payment_status
        update_cart_status
        start_order
        send_success_email
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
      order_starter.call
    end

    def order_starter
      @order_starter ||= Orders::StartOrder.new(payment: payment)
    end

    def send_success_email
      Payments::SuccessEmailSender.new(payment: payment, order: order_starter.order).call
    end
  end
end
