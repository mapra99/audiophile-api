module Recommendations
  class RecommendationsBuilder
    attr_reader :product, :product_recommendations

    RECOMMENDATIONS_PER_PRODUCT = 4

    def initialize(product_id:)
      self.product_id = product_id
    end

    def call
      product = find_product
      session_ids = find_sessions_that_viewed_product(product)
      sessions_product_page_views = find_sessions_product_page_views(session_ids)
      grouped_page_views = group_pageviews_by_product(sessions_product_page_views)

      ActiveRecord::Base.transaction do
        delete_previous_recommendations(product)
        create_new_recommendations(product, grouped_page_views)
      end

      product_recommendations
    end

    private

    attr_accessor :product_id
    attr_writer :product_recommendations

    def find_product
      Product.find(product_id)
    end

    def find_sessions_that_viewed_product(product)
      product_page_views = product.page_views
      product_page_views.pluck(:session_id)
    end

    def find_sessions_product_page_views(session_ids)
      page_views_ids = PageView.where(session_id: session_ids).pluck(:id)
      ProductPageView.where(page_view_id: page_views_ids).where.not(product_id: product_id)
    end

    def group_pageviews_by_product(sessions_product_page_views)
      sessions_product_page_views.group(:product_id).count
    end

    def delete_previous_recommendations(product)
      product.product_recommendations.destroy_all
    end

    def create_new_recommendations(product, grouped_page_views)
      recommended_product_ids = grouped_page_views.first(RECOMMENDATIONS_PER_PRODUCT).map { |p| p[0] }
      self.product_recommendations = recommended_product_ids.map do |recommended_product_id|
        product.product_recommendations.create!(recommendation_id: recommended_product_id)
      end
    end
  end
end
