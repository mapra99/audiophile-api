json.id product.id
json.name product.name
json.slug product.slug
json.base_price product.base_price
json.featured product.featured
json.created_at product.created_at
json.updated_at product.updated_at

if product.image.attached?
  json.image do
    json.url product.image.url
  end
end

json.category do
  json.partial! 'product_category', product_category: product.product_category
end

json.contents product.product_contents do |content|
  json.partial! 'product_content', product_content: content
end
