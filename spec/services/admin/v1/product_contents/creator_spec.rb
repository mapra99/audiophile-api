require 'rails_helper'

RSpec.describe Admin::V1::ProductContents::Creator do
  subject(:creator) { described_class.new(params: params) }

  let(:product) { create(:product) }
  let(:product_id) { product.id }
  let(:content_field) { fixture_file_upload('product_image.png', 'image/png') }
  let(:params) do
    {
      product_id: product_id,
      key: 'main_thumbnail',
      content: content_field
    }
  end

  describe '#call' do
    subject(:result) { creator.call }

    it 'succeeds' do
      expect(result.success?).to eq(true)
    end

    it 'creates a new product content' do
      expect { creator.call }.to change(ProductContent, :count).by(1)
    end

    describe 'the new product content' do
      let(:new_content) { creator.product_content }

      before do
        creator.call
      end

      it 'has a key set by the params' do
        expect(new_content.key).to eq(params[:key])
      end

      it 'has a file attached' do
        expect(new_content.files.attached?).to eq(true)
      end
    end

    describe 'when params contain a text value' do
      let(:content_field) { 'Some Text' }

      before do
        creator.call
      end

      it "is stored in the table's value" do
        expect(creator.product_content.value).to eq('Some Text')
      end
    end

    describe 'when there is already an existing content key' do
      before do
        create(:text_product_content, key: 'main_thumbnail', product_id: product_id)
      end

      it 'does not create a new content' do
        expect { creator.call }.not_to change(ProductContent, :count)
      end

      it 'returns a failure' do
        expect(result.failure?).to eq(true)
      end

      it 'returns the right error code' do
        expect(result.failure[:code]).to eq(:invalid_product_content)
      end
    end

    describe "when product isn't found" do
      let(:product_id) { 'something' }

      it 'returns a failure' do
        expect(result.failure?).to eq(true)
      end

      it 'returns the right error code' do
        expect(result.failure[:code]).to eq(:product_not_found)
      end
    end

    describe 'when key param is missing' do
      let(:params) do
        {
          product_id: product_id,
          content: content_field
        }
      end

      it 'returns a failure' do
        expect(result.failure?).to eq(true)
      end

      it 'returns the right error code' do
        expect(result.failure[:code]).to eq(:wrong_params)
      end
    end

    describe 'when product_id param is missing' do
      let(:params) do
        {
          key: 'main_thumbnail',
          content: content_field
        }
      end

      it 'returns a failure' do
        expect(result.failure?).to eq(true)
      end

      it 'returns the right error code' do
        expect(result.failure[:code]).to eq(:wrong_params)
      end
    end

    describe 'when content param is missing' do
      let(:params) do
        {
          key: 'main_thumbnail',
          product_id: product_id
        }
      end

      it 'returns a failure' do
        expect(result.failure?).to eq(true)
      end

      it 'returns the right error code' do
        expect(result.failure[:code]).to eq(:wrong_params)
      end
    end
  end
end
