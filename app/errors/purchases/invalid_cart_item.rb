module Purchases
  class InvalidCartItem < StandardError
    attr_reader :item_errors

    def initialize(item_errors)
      @item_errors = item_errors
      message = item_errors.join(', ')

      super(message)
    end
  end
end
