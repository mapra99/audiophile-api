require 'rails_helper'

RSpec.describe Payment, type: :model do
  subject(:payment) { build(:payment) }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:purchase_cart) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_presence_of(:provider_id) }
  end
end
