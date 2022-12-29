require 'rails_helper'

RSpec.describe PageView do
  subject(:page_view) { build(:page_view) }

  describe 'associations' do
    it { is_expected.to belong_to(:session) }
    it { is_expected.to have_one(:product_page_view) }
  end

  describe '#create_product_page_view hook' do
    before do
      page_view.save
    end

    describe 'when page path is a product page' do
      subject(:page_view) { build(:page_view, page_path: "/products/#{product.slug}") }

      let(:product) { create(:product) }

      it 'creates a product page view record' do
        expect(page_view.product_page_view).not_to be_nil
      end

      it 'gets asociated with the product' do
        expect(page_view.product_page_view.product).to eq(product)
      end
    end

    describe 'when page path is not a product page' do
      subject(:page_view) { build(:page_view, page_path: '/') }

      it 'does not create a product page view' do
        expect(page_view.product_page_view).to be_nil
      end
    end
  end
end
