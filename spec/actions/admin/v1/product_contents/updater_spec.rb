require 'rails_helper'

RSpec.describe Admin::V1::ProductContents::Updater do
  subject(:updater) { described_class.new(params: params) }

  let(:product) { create(:product) }
  let(:product_id) { product.id }
  let(:params) do
    {
      product_id: product_id,
      key: 'main_thumbnail',
      content: 'holi'
    }
  end

  before do
    create(:text_product_content, product_id: product_id, key: 'main_thumbnail')
  end

  describe '#call' do
    subject(:result) { updater.call }

    it 'succeeds' do
      expect(result.success?).to eq(true)
    end

    describe 'the updated product content' do
      before do
        updater.call
      end

      it 'has a key set by the params' do
        expect(updater.product_content.key).to eq(params[:key])
      end

      it 'has the new key content' do
        expect(updater.product_content.value).to eq('holi')
      end
    end
  end
end
