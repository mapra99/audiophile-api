require 'rails_helper'

RSpec.describe Recommendations::RecommendationsBuilder do
  subject(:builder) { described_class.new(product_id: product_id) }

  let(:product) { create(:product) }
  let(:product_id) { product.id }

  describe '#call' do
    subject(:product_recommendations) { builder.product_recommendations }

    let(:recommended_product) { create(:product) }

    before do
      session = create(:session)
      create(:page_view, page_path: "/products/#{product.slug}", session: session)
      create(:page_view, page_path: "/products/#{recommended_product.slug}", session: session)

      builder.call
    end

    it 'returns the recommended product based on all sessions that also saw the target product' do
      expect(product_recommendations.first.recommendation).to eq(recommended_product)
    end
  end
end
