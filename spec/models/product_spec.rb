require 'rails_helper'

RSpec.describe Product, type: :model do
  subject(:product) { build(:product) }

  describe 'associations' do
    it { is_expected.to have_one_attached(:image) }
    it { is_expected.to have_many(:product_contents) }
    it { is_expected.to belong_to(:product_category) }
    it { is_expected.to have_many(:stocks) }
    it { is_expected.to have_many(:toppings) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_presence_of(:base_price) }
  end

  describe '#total_quantity' do
    before do
      product.save
      product.stocks.create(quantity: 10)
      product.stocks.create(quantity: 15)
      product.stocks.create(quantity: 0)
    end

    it 'computes the total quantity based on stocks' do
      expect(product.total_quantity).to eq(25)
    end
  end
end
