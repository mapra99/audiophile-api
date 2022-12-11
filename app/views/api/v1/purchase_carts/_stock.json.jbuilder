json.uuid stock.uuid
json.quantity stock.quantity
json.product do
  json.partial! 'product', product: stock.product
end
