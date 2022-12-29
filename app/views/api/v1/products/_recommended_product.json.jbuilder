json.name product.name
json.slug product.slug
json.base_price product.base_price
json.featured product.featured
json.total_quantity product.total_quantity
json.created_at product.created_at
json.updated_at product.updated_at

if product.image.attached?
  json.image do
    json.url product.image.url
  end
end
