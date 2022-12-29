# frozen_string_literal: true

module Recommendations
  class RecommendationsBuilderJob < ApplicationJob
    queue_as :default

    def perform
      Product.all.each do |product|
        Recommendations::RecommendationsBuilder.new(product_id: product.id).call
      rescue StandardError => e
        Rails.logger.error(e)
      end
    end
  end
end
