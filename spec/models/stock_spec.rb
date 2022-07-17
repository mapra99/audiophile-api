require 'rails_helper'

RSpec.describe Stock, type: :model do
  subject(:stock) { build(:stock) }

  describe 'associations' do
    it { is_expected.to belong_to(:product) }
    it { is_expected.to have_many(:stock_toppings) }
    it { is_expected.to have_many(:toppings) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:quantity) }
  end

  describe 'uuid' do
    before do
      stock.uuid = nil
      stock.save
    end

    it 'is generated on creation' do
      expect(stock.uuid).not_to be_nil
    end
  end

  describe '.filter_exactly_by_toppings' do
    subject(:result) { described_class.filter_exactly_by_toppings(stock.toppings) }

    let!(:stock) { create(:stock) }

    it 'returns the stock that has the exact given set of toppings' do
      expect(result).to eq([stock])
    end
  end

  describe '#price' do
    subject(:result) { stock.price }

    let(:product) { create(:product, base_price: 400) }
    let(:topping) { create(:topping, price_change: '+100', product: product) }
    let(:stock_topping) { create(:stock_topping, topping: topping) }
    let(:stock) { create(:stock, product: product, stock_toppings: [stock_topping]) }

    it 'computes the price adding up product price and toppings variations' do
      expect(result).to eq(500.0)
    end
  end
end
