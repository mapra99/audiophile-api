require 'rails_helper'

RSpec.describe PurchaseCartExtraFee, type: :model do
  subject(:extra_fee) { build(:purchase_cart_extra_fee) }

  describe 'associations' do
    it { is_expected.to belong_to(:purchase_cart) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_presence_of(:key) }
    it { is_expected.to validate_uniqueness_of(:key).scoped_to(:purchase_cart_id) }
    it { is_expected.to validate_inclusion_of(:key).in_array(PurchaseCartExtraFee::KEYS) }
  end
end
