module Orders
  class StartOrder
    attr_reader :order

    def initialize(payment:)
      self.payment = payment
    end

    def call
      ActiveRecord::Base.Transaction do
        create_order
        reduce_stocks_amounts
      end
    end

    private

    attr_accessor :payment
    attr_writer :order

    def create_order
      self.order = Order.create!(
        payment: payment,
        user_location: payment.purchase_cart.user_location,
        status: Order::ACTIVE
      )
    end

    def reduce_stocks_amounts
      cart_items = order.purchase_cart.purchase_cart_items
      cart_items.each(&:reduce_stock_amount!)
    end
  end
end
