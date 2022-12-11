json.name product.name
json.slug product.slug

if product.image.attached?
  json.image do
    json.url product.image.url
  end
end
