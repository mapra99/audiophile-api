require 'rails_helper'

RSpec.describe Admin::V1::Products::Updater do
  subject(:updater) { described_class.new(product_id: product_id, params: params) }

  let(:product_id) { product.id }
  let(:product) { create(:product) }
  let(:product_category) { create(:product_category) }
  let(:category_id) { product_category.id }
  let(:params) do
    {
      name: 'Some Product',
      price: 450,
      featured: false,
      category_id: category_id,
      image: fixture_file_upload('product_image.png', 'image/png')
    }
  end

  describe '#call' do
    subject(:result) { updater.call }

    it 'succeeds' do
      expect(result.success?).to eq(true)
    end

    describe 'the product' do
      before do
        updater.call
        product.reload
      end

      it 'has a name set by the params' do
        expect(product.name).to eq(params[:name])
      end

      it 'has a price set by the params' do
        expect(product.base_price).to eq(params[:price])
      end

      it 'is featured per the params' do
        expect(product.featured).to eq(params[:featured])
      end

      it 'has a category id per the params' do
        expect(product.product_category.id).to eq(params[:category_id])
      end

      it 'has a image attached' do
        expect(product.image.attached?).to eq(true)
      end
    end

    describe 'when product is not found' do
      let(:product_id) { 1313 }

      it 'returns a failure' do
        expect(result.failure?).to eq(true)
      end

      it 'returns product_not_found as failure code' do
        expect(result.failure[:code]).to eq(:product_not_found)
      end
    end
  end
end
