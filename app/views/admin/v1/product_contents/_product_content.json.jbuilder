json.id product_content.id
json.key product_content.key
json.created_at product_content.created_at
json.updated_at product_content.updated_at

if product_content.value.present?
  json.content product_content.value
else
  json.content product_content.files do |file|
    json.url file.url
  end
end
