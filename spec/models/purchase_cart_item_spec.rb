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
end
