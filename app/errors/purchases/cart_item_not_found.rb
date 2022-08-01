module Purchases
  class CartItemNotFound < StandardError
    attr_reader :item_uuid

    def initialize(item_uuid)
      @item_uuid = item_uuid
      message = "Cart Item with uuid '#{@item_uuid}' not found"

      super(message)
    end
  end
end
