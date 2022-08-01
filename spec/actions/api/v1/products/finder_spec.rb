require 'rails_helper'

RSpec.describe Api::V1::Products::Finder do
  subject(:finder) { described_class.new(slug: product_slug) }

  let(:product_slug) { Product.last.slug }

  describe '#call' do
    subject(:result) { finder.call }

    before do
      create(:product)
    end

    it 'succeeds' do
      expect(result.success?).to eq true
    end

    it 'returns the found product' do
      expect(result.value!).to eq(Product.last)
    end

    describe 'when product is not found' do
      let(:product_slug) { nil }

      it 'fails' do
        expect(result.failure?).to eq(true)
      end

      it 'returns a not found code' do
        expect(result.failure).to eq({ code: :not_found })
      end
    end
  end
end
