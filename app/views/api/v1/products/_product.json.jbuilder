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

json.category do
  json.partial! 'product_category', product_category: product.product_category
end

json.contents do
  product.product_contents.each do |product_content|
    json.partial! 'product_content', product_content: product_content
  end
end

json.toppings do
  grouped_toppings = product.toppings.grouped_by_key
  grouped_toppings.each do |key, toppings|
    json.set! key, toppings.pluck(:value)
  end
end

json.recommendations do
  product.recommended_products do |recommended_product|
    json.partial! 'recommended_product', product: recommended_product
  end
end
