require 'rails_helper'

RSpec.describe Admin::V1::ProductCategories::Creator do
  subject(:creator) { described_class.new(params: params) }

  let(:params) do
    {
      name: 'Headphonez',
      image: fixture_file_upload('product_image.png', 'image/png')
    }
  end

  describe '#call' do
    subject(:result) { creator.call }

    it 'succeeds' do
      expect(result.success?).to eq(true)
    end

    it 'creates a new product category' do
      expect { creator.call }.to change(ProductCategory, :count).by(1)
    end

    describe 'the new category' do
      let(:new_category) { creator.product_category }

      before do
        creator.call
      end

      it 'has a name set by the params' do
        expect(new_category.name).to eq(params[:name])
      end

      it 'has an image attached' do
        expect(new_category.image.attached?).to eq(true)
      end
    end

    describe 'when there is already an existing product name' do
      before do
        create(:product_category, name: params[:name])
      end

      it 'does not create a new product' do
        expect { creator.call }.not_to change(ProductCategory, :count)
      end

      it 'returns a failure' do
        expect(result.failure?).to eq(true)
      end

      it 'returns the right error code' do
        expect(result.failure[:code]).to eq(:invalid_product_category)
      end
    end

    describe 'when service failes due to unhandled error' do
      before do
        allow(ProductCategory).to receive(:new).and_raise(StandardError, 'ERROR MESSAGE')
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
