module Purchases
  class CartNotFound < StandardError
    attr_reader :cart_uuid

    def initialize(cart_uuid)
      @cart_uuid = cart_uuid
      message = "Cart with uuid '#{@cart_uuid}' not found"

      super(message)
    end
  end
end
