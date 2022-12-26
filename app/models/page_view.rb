class PageView < ApplicationRecord
  belongs_to :session
  has_one :product_page_view, dependent: :destroy

  PRODUCT_PAGES_PATH = /\/products\/([\w|-]+)/

  after_create :create_product_page_view

  private

  def create_product_page_view
    product_page = PRODUCT_PAGES_PATH.match(page_path)
    return if product_page.blank?

    slug = product_page.captures[0]
    product = Product.find_by(slug: slug)

    ProductPageView.create(page_view: self, product: product)
  end
end
