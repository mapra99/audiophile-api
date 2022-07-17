json.uuid stock.uuid
json.quantity stock.quantity
json.price stock.price
json.toppings do
  stock.toppings.each do |topping|
    json.partial! 'topping', topping: topping
  end
end
