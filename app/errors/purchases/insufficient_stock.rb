module Purchases
  class InsufficientStock < StandardError
    attr_reader :stock_uuid, :quantity

    def initialize(stock_uuid, quantity)
      @stock_uuid = stock_uuid
      @quantity = quantity
      message = "Stock with uuid '#{@stock_uuid}' has less than #{quantity} units available"

      super(message)
    end
  end
end
