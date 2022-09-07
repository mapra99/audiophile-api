module Payments
  class ProviderError < StandardError
    def initialize(provider_message)
      message = "Payment provider error: #{provider_message}"

      super(message)
    end
  end
end
