require 'rails_helper'

RSpec.describe PurchaseCart, type: :model do
  subject(:cart) { build(:purchase_cart) }

  describe 'associations' do
    it { is_expected.to have_many(:purchase_cart_items) }
    it { is_expected.to have_many(:purchase_cart_extra_fees) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:total_price) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_inclusion_of(:status).in_array(PurchaseCart::STATUS_TYPES) }
  end

  describe 'uuid' do
    before do
      cart.uuid = nil
      cart.save
    end

    it 'is generated on creation' do
      expect(cart.uuid).not_to be_nil
    end
  end

  describe '#update_total_price!' do
    subject(:cart) do
      create(
        :purchase_cart,
        purchase_cart_items: [cart_item],
        purchase_cart_extra_fees: [extra_fee]
      )
    end

    let(:cart_item) { create(:purchase_cart_item, quantity: 2, unit_price: 15.5) }
    let(:extra_fee) { create(:purchase_cart_extra_fee, price: 100) }

    before do
      cart.update_total_price!
    end

    it "updates the total price given the cart items and extra fees" do
      expect(cart.total_price).to eq(131.0)
    end
  end
end
