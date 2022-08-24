module Purchases
  class CartItemGenerator
    attr_reader :cart_item

    def initialize(stock_uuid:, quantity:, session: nil, cart: nil, cart_uuid: nil)
      self.cart = cart
      self.cart_uuid = cart_uuid
      self.stock_uuid = stock_uuid
      self.quantity = quantity
      self.session = session
    end

    def call
      find_cart if cart.blank?
      find_stock
      validate_stock_existence
      create_item
      update_cart_price
    end

    private

    attr_accessor :cart_uuid, :stock_uuid, :quantity, :stock, :cart, :session
    attr_writer :cart_item

    def find_cart
      self.cart = session.purchase_carts.find_by(uuid: cart_uuid)
      raise CartNotFound, cart_uuid if cart.blank?
    end

    def find_stock
      self.stock = Stock.find_by(uuid: stock_uuid)
      raise StockNotFound, stock_uuid if stock.blank?
    end

    def validate_stock_existence
      raise InsufficientStock.new(stock_uuid, quantity) if stock.quantity < quantity
    end

    # rubocop:disable Metrics/AbcSize
    def create_item
      self.cart_item = cart.purchase_cart_items.find_or_initialize_by(stock: stock)

      cart_item.quantity = quantity
      cart_item.unit_price = stock.price

      raise InvalidCartItem, cart_item.errors.full_messages unless cart_item.save
    end
    # rubocop:enable Metrics/AbcSize

    def update_cart_price
      cart.update_total_price!
    end
  end
end
