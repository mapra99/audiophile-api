module Payments
  class PaymentNotFound < StandardError
    attr_reader :provider_id

    def initialize(provider_id)
      @provider_id = provider_id
      message = "Stripe payment with provider_id #{provider_id} not found"

      super(message)
    end
  end
end
