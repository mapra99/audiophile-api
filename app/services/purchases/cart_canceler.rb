module Purchases
  class CartCanceler
    INVALID_STATUSES = [
      PurchaseCart::PAID
    ].freeze

    def initialize(cart_uuid:, owner:)
      self.cart_uuid = cart_uuid
      self.owner = owner
    end

    def call
      find_cart
      validate_status
      update_status
    end

    private

    attr_accessor :cart_uuid, :cart, :owner

    def find_cart
      self.cart = owner.purchase_carts.find_by(uuid: cart_uuid)
      raise CartNotFound, cart_uuid if cart.blank?
    end

    def validate_status
      raise InvalidStatusForCancelation, cart_uuid if INVALID_STATUSES.include?(cart.status)
    end

    def update_status
      cart.update!(status: PurchaseCart::CANCELED)
    end
  end
end
