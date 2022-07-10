require 'rails_helper'

RSpec.describe StockTopping, type: :model do
  subject { build(:stock_topping) }

  describe 'associations' do
    it { is_expected.to belong_to(:stock) }
    it { is_expected.to belong_to(:topping) }
  end

  describe 'validations' do
    describe 'uniqueness of topping keys within scope of stock' do
      subject(:stock_topping) { build(:stock_topping, stock: stock, topping: topping) }

      let(:stock) { create(:stock) }
      let(:topping) { create(:topping, key: 'something') }

      before do
        create(:topping, key: 'something', stock_toppings: [stock_topping])
      end

      it 'is not valid' do
        expect(stock_topping).not_to be_valid
      end
    end

    describe 'uniqueness of stock toppings key-value pairs within scope of product' do
      subject(:stock_topping) { build(:stock_topping, stock: stock1, topping: topping) }

      let(:product) { create(:product) }
      let(:stock1) { create(:stock, product: product) }
      let(:stock2) { create(:stock, product: product) }
      let(:topping) { create(:topping, product: product, key: 'color', value: 'blue', stocks: [stock2]) }

      before do
        topping.save
      end

      it 'is not valid' do
        expect(stock_topping).not_to be_valid
      end
    end
  end
end
