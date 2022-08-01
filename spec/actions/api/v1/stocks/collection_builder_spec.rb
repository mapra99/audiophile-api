require 'rails_helper'

RSpec.describe Api::V1::Stocks::CollectionBuilder do
  subject { described_class.new }

  let(:product) { create(:product) }
  let(:result) { subject.call(product_slug: product.slug) }

  describe 'when no filters' do
    before do
      create_list(:stock, 2, product: product)
    end

    it 'succeeds' do
      expect(result.success?).to eq true
    end

    it 'returns all stocks' do
      expect(result.value!.count).to eq 2
    end
  end

  describe 'when using toppings filters' do
    let(:result) { subject.call(product_slug: product.slug, toppings_filters: { color: 'black', size: 'M' }) }

    let(:color_topping) { create(:topping, product: product, key: 'color', value: 'black') }
    let(:size_topping) { create(:topping, product: product, key: 'size', value: 'M') }
    let!(:target_stock) { create(:stock, product: product) }

    before do
      create(:stock_topping, topping: color_topping, stock: target_stock)
      create(:stock_topping, topping: size_topping, stock: target_stock)

      create_list(:stock, 2, product: product)
    end

    it 'succeeds' do
      expect(result.success?).to eq true
    end

    it 'returns the stock that has the toppings specified' do
      expect(result.value!).to eq([target_stock])
    end

    describe 'when topping is not found' do
      let(:filters) { { color: 'black', size: 'M', something: 'wrong' } }
      let(:result) { subject.call(product_slug: product.slug, toppings_filters: filters) }

      it 'fails' do
        expect(result.failure?).to eq true
      end

      it 'provides an error code' do
        expect(result.failure[:code]).to eq(:topping_not_found)
      end
    end
  end

  describe 'when an internal error is raised' do
    before do
      allow(Product).to receive(:find_by).and_raise(StandardError, 'ERROR')
    end

    it 'fails' do
      expect(result.failure?).to eq true
    end

    it 'provides an error code' do
      expect(result.failure).to eq({ code: :internal_error })
    end
  end

  describe 'when product is not found' do
    let(:result) { subject.call(product_slug: 'something') }

    it 'fails' do
      expect(result.failure?).to eq true
    end

    it 'provides an error code' do
      expect(result.failure).to eq({ code: :product_not_found })
    end
  end
end
