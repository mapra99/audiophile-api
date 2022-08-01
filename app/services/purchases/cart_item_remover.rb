module Purchases
  class CartItemRemover
    def initialize(item_uuid:)
      self.item_uuid = item_uuid
    end

    def call
      find_item
      find_cart
      delete_item
      update_cart_price
    end

    private

    attr_accessor :item_uuid, :item, :cart

    def find_item
      self.item = PurchaseCartItem.find_by(uuid: item_uuid)
      raise CartItemNotFound, item_uuid if item.blank?
    end

    def find_cart
      self.cart = item.purchase_cart
    end

    def delete_item
      item.destroy!
    end

    def update_cart_price
      cart.update_total_price!
    end
  end
end
