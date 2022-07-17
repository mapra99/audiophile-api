module Validators
  class StockToppingsValidator < ActiveModel::Validator
    def validate(record)
      @record = record
      @stock = record.stock
      @topping = record.topping

      return if stock.blank?
      return if topping.blank?

      record.errors.add :stock, 'topping keys provided must be unique' if topping_key_duplicated?
      record.errors.add :stock, 'another stock with the same toppings already exists' if toppings_set_duplicated?
    end

    private

    attr_reader :record, :stock, :topping

    def topping_key_duplicated?
      keys = stock.toppings.pluck(:key)
      keys.include?(topping.key)
    end

    def toppings_set_duplicated?
      return false if stock.product.blank?

      other_stocks = stock.product.stocks.where.not(id: stock.id)
      other_stocks.any? do |other_stock|
        are_toppings_equal?(other_stock)
      end
    end

    def are_toppings_equal?(other_stock)
      other_stock.toppings.all? do |other_topping|
        stock_topping = topping if other_topping.key == topping.key
        stock_topping ||= stock.toppings.find_by(key: other_topping.key)
        return false if stock_topping.blank?

        stock_topping.value == other_topping.value
      end
    end
  end
end
