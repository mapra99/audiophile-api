module Payments
  class FailureEmailSender
    TEMPLATE_ID = 'd-c3d716b664784d6ca1bad0685508df2f'.freeze

    def initialize(payment:)
      self.payment = payment
    end

    def call
      resolve_recipient
      build_template_data

      send_email
    end

    private

    attr_accessor :payment, :recipient, :template_data

    def resolve_recipient
      self.recipient = payment.user.email
    end

    def build_template_data
      self.template_data = {
        user_name: payment.user.name,
        total_price: payment.amount,
        cart_uuid: payment.purchase_cart.uuid
      }
    end

    def serialize_cart_items
      payment.purchase_cart.purchase_cart_items.map do |cart_item|
        {
          name: cart_item.stock.product.name,
          quantity: cart_item.quantity,
          total_price: cart_item.total_price
        }
      end
    end

    def send_email
      Communications::EmailSenderJob.perform_later(
        topic: Communication::FAILED_PAYMENT_TOPIC,
        sender: EmailCommunication::PAYMENTS_SENDER_EMAIL,
        recipient: recipient,
        template_id: TEMPLATE_ID,
        template_data: template_data,
        target: payment.user
      )
    end
  end
end
