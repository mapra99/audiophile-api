require_relative './seeds/product_categories'
require_relative './seeds/featured_products'
require_relative './seeds/products'

# Create product categories
Seeds::ProductCategories.seed!

# Create products
Seeds::FeaturedProducts.seed!
Seeds::Products.seed!
