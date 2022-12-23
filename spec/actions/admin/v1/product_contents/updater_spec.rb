require 'rails_helper'

RSpec.describe Admin::V1::ProductContents::Updater do
  subject(:updater) { described_class.new(params: params) }

  let(:product) { create(:product) }
  let(:product_id) { product.id }
  let(:product_content) { create(:attachment_product_content, key: 'main_thumbnail') }
  let(:content_field) { fixture_file_upload('product_image.png', 'image/png') }
  let(:params) do
    {
      product_id: product_id,
      key: 'main_thumbnail',
      content: content_field
    }
  end

  describe '#call' do
    subject(:result) { updater.call }

    it 'succeeds' do
      expect(result.success?).to eq(true)
    end

    describe 'the updated product content' do
      before do
        updater.call
        product_content.reload
      end

      it 'has a key set by the params' do
        expect(product_content.key).to eq(params[:key])
      end

      it 'has a file attached' do
        expect(product_content.files.attached?).to eq(true)
      end
    end
  end
end
