module Purchases
  class ExtraFeesGenerator
    SHIPPING_PRICE = 10.0

    def initialize(cart: nil, cart_uuid: nil)
      self.cart = cart
      self.cart_uuid = cart_uuid
    end

    def call
      find_cart if cart.blank?
      create_shipping_fee
      update_cart_price
    end

    private

    attr_accessor :cart_uuid, :cart

    def find_cart
      self.cart = PurchaseCart.find_by(uuid: cart_uuid)
      raise CartNotFound, cart_uuid if cart.blank?
    end

    def create_shipping_fee
      shipping_fee = cart.purchase_cart_extra_fees.find_or_initialize_by(
        key: PurchaseCartExtraFee::SHIPPING_FEE
      )

      shipping_fee.price = SHIPPING_PRICE

      raise InvalidExtraFees, shipping_fee.errors.full_messages unless shipping_fee.save
    end

    def update_cart_price
      cart.update_total_price!
    end
  end
end
