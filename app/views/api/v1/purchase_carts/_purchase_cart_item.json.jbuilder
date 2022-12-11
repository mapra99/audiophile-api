json.uuid purchase_cart_item.uuid
json.quantity purchase_cart_item.quantity
json.unit_price purchase_cart_item.unit_price
json.price purchase_cart_item.total_price

json.stock do
  json.partial! 'stock', stock: purchase_cart_item.stock
end
