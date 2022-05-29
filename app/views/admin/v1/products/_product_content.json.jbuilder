json.id product_content.id
json.key product_content.key
json.value product_content.value
json.created_at product_content.created_at
json.updated_at product_content.updated_at
json.files product_content.files do |file|
  json.url file.url
end
