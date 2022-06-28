value = product_content.value.presence || product_content.files.map(&:url)

json.set! product_content.key, value
