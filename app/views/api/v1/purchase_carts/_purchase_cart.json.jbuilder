json.uuid purchase_cart.uuid
json.total_price purchase_cart.total_price
json.status purchase_cart.status
json.user_location_uuid purchase_cart.user_location&.uuid
json.items purchase_cart.purchase_cart_items do |cart_item|
  json.partial! 'purchase_cart_item', purchase_cart_item: cart_item
end

json.extra_fees purchase_cart.purchase_cart_extra_fees do |extra_fee|
  json.partial! 'purchase_cart_extra_fee', purchase_cart_extra_fee: extra_fee
end
