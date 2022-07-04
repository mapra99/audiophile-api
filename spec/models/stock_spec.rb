require 'rails_helper'

RSpec.describe Stock, type: :model do
  subject { build(:stock) }

  describe 'associations' do
    it { is_expected.to belong_to(:product) }
    it { is_expected.to have_many(:stock_toppings) }
    it { is_expected.to have_many(:toppings) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:quantity) }
  end
end
