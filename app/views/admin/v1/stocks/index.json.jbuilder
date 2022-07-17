json.array! @stocks do |stock|
  json.partial! 'stock', stock: stock
end
