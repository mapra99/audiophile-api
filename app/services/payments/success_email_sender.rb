module Payments
  class SuccessEmailSender
    SUCCESS_EMAIL_TEMPLATE_ID = 'd-725277b4a66441d98b0659a5057578ac'.freeze

    def initialize(payment:, order:)
      self.payment = payment
      self.order = order
    end

    def call
      resolve_recipient
      build_template_data

      send_email
    end

    private

    attr_accessor :payment, :order, :recipient, :template_data

    def resolve_recipient
      self.recipient = payment.user.email
    end

    def build_template_data
      self.template_data = {
        user_name: payment.user.name,
        total_price: payment.amount,
        order_uuid: order.uuid,
        cart_items: serialize_cart_items,
        extra_fees: serialize_extra_fees
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

    def serialize_extra_fees
      payment.purchase_cart.purchase_cart_extra_fees.map do |extra_fee|
        {
          name: extra_fee.key.humanize,
          total_price: extra_fee.price
        }
      end
    end

    def send_email
      Communications::EmailSenderJob.perform_later(
        topic: Communication::SUCCESS_PAYMENT_TOPIC,
        sender: EmailCommunication::PAYMENTS_SENDER_EMAIL,
        recipient: recipient,
        template_id: SUCCESS_EMAIL_TEMPLATE_ID,
        template_data: template_data,
        target: payment.user
      )
    end
  end
end
