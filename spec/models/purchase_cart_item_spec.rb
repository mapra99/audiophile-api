require 'rails_helper'

RSpec.describe PurchaseCartItem, type: :model do
  subject(:cart_item) { build(:purchase_cart_item) }

  describe 'associations' do
    it { is_expected.to belong_to(:purchase_cart) }
    it { is_expected.to belong_to(:stock) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:quantity) }
    it { is_expected.to validate_presence_of(:unit_price) }
    it { is_expected.to validate_uniqueness_of(:stock_id).scoped_to(:purchase_cart_id) }
  end

  describe '#total_price' do
    subject(:cart_item) { build(:purchase_cart_item, quantity: 2, unit_price: 15.5) }

    it 'computes the total price given the quantity and unit price' do
      expect(cart_item.total_price).to eq(31.0)
    end
  end

  describe 'uuid' do
    before do
      cart_item.uuid = nil
      cart_item.save
    end

    it 'is generated on creation' do
      expect(cart_item.uuid).not_to be_nil
    end
  end

  describe '#reduce_stock_amount!' do
    let(:stock) { create(:stock, quantity: 10) }
    let(:cart_item) { create(:purchase_cart_item, stock: stock, quantity: 3) }

    before do
      cart_item.reduce_stock_amount!
    end

    it 'reduces the stock amount to 7' do
      expect(stock.quantity).to eq(7)
    end
  end
end
