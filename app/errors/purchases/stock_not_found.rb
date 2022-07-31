module Purchases
  class StockNotFound < StandardError
    attr_reader :stock_uuid

    def initialize(stock_uuid)
      @stock_uuid = stock_uuid
      message = "Stock with uuid '#{@stock_uuid}' not found"

      super(message)
    end
  end
end
