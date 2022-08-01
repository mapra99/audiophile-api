require 'rails_helper'

RSpec.describe Api::V1::ProductCategories::Finder do
  subject(:finder) { described_class.new(slug: category_slug) }

  let(:category_slug) { ProductCategory.last.slug }

  describe '#call' do
    subject(:result) { finder.call }

    before do
      create(:product_category)
    end

    it 'succeeds' do
      expect(result.success?).to eq true
    end

    it 'returns the found product' do
      expect(result.value!).to eq(ProductCategory.last)
    end

    describe 'when product is not found' do
      let(:category_slug) { nil }

      it 'fails' do
        expect(result.failure?).to eq(true)
      end

      it 'returns a not found code' do
        expect(result.failure).to eq({ code: :not_found })
      end
    end
  end
end
