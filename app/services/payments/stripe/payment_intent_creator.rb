module Payments
  module Stripe
    class PaymentIntentCreator
      attr_reader :payment_intent

      CURRENCY = 'usd'.freeze

      def initialize(amount:)
        self.amount = amount
      end

      def call
        set_api_key
        convert_currency
        create_intent
      end

      private

      attr_accessor :amount, :amount_in_cents
      attr_writer :payment_intent

      def set_api_key
        ::Stripe.api_key = ENV.fetch('STRIPE_API_SECRET_KEY', '')
      end

      def convert_currency
        self.amount_in_cents = (amount * 100).to_i
      end

      def create_intent
        self.payment_intent = ::Stripe::PaymentIntent.create(
          amount: amount_in_cents,
          currency: CURRENCY,
          automatic_payment_methods: {
            enabled: true
          }
        )
      rescue ::Stripe::StripeError => e
        raise Payments::ProviderError, e.message
      end
    end
  end
end
