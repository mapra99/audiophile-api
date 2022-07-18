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
end
