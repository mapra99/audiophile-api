require 'rails_helper'

RSpec.describe Admin::V1::ProductCategories::Updater do
  subject(:updater) { described_class.new(category_id: category_id, params: params) }

  let(:product_category) { create(:product_category) }
  let(:category_id) { product_category.id }
  let(:params) do
    {
      name: 'Headphonez',
      image: fixture_file_upload('product_image.png', 'image/png')
    }
  end

  describe '#call' do
    subject(:result) { updater.call }

    it 'succeeds' do
      expect(result.success?).to eq(true)
    end

    describe 'the updated category' do
      before do
        updater.call
        product_category.reload
      end

      it 'has a name set by the params' do
        expect(product_category.name).to eq(params[:name])
      end

      it 'has an image attached' do
        expect(product_category.image.attached?).to eq(true)
      end
    end

    describe 'when service failes due to unhandled error' do
      before do
        allow(ProductCategory).to receive(:find).and_raise(StandardError, 'ERROR MESSAGE')
      end

      it 'returns a failure' do
        expect(result.failure?).to eq(true)
      end

      it 'returns internal_error as failure code' do
        expect(result.failure[:code]).to eq(:internal_error)
      end
    end
  end
end
