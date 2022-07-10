json.id stock.id
json.product_id stock.product_id
json.quantity stock.quantity
json.toppings do
  stock.toppings.each do |topping|
    json.partial! 'topping', topping: topping
  end
end
