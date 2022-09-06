require 'rails_helper'

RSpec.describe Order, type: :model do
  subject { build(:order) }

  describe 'associations' do
    it { is_expected.to belong_to(:payment) }
    it { is_expected.to belong_to(:user_location) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:status) }
  end
end
