module Purchases
  class InvalidStatusForCancelation < StandardError
    attr_reader :cart_uuid

    def initialize(cart_uuid)
      @cart_uuid = cart_uuid
      message = "Cart with uuid '#{@cart_uuid}' cannot be canceled because current status does not allow it"

      super(message)
    end
  end
end
