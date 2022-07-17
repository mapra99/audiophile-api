json.name product_category.name
json.slug product_category.slug
json.created_at product_category.created_at
json.updated_at product_category.updated_at

if product_category.image.attached?
  json.image do
    json.url product_category.image.url
  end
end

json.products product_category.products do |product|
  json.partial! 'product', product: product
end
