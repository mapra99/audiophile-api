module Payments
  class StartPayment
    attr_reader :payment, :payment_intent

    def initialize(purchase_cart:, user:)
      self.purchase_cart = purchase_cart
      self.user = user
    end

    def call
      create_payment_intent
      create_payment
    end

    private

    attr_accessor :purchase_cart, :user
    attr_writer :payment, :payment_intent

    def create_payment_intent
      intent_creator = Payments::Stripe::PaymentIntentCreator.new(amount: purchase_cart.total_price)
      intent_creator.call

      self.payment_intent = intent_creator.payment_intent
    end

    def create_payment
      self.payment = Payment.create!(
        purchase_cart: purchase_cart,
        user: user,
        amount: payment_amount,
        provider_id: payment_intent['id'],
        status: Payment::STARTED
      )
    rescue ActiveRecord::RecordInvalid => e
      raise InvalidPayment, [e.message]
    end

    def payment_amount
      purchase_cart.total_price
    end
  end
end
