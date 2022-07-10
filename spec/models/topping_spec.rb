require 'rails_helper'

RSpec.describe Topping, type: :model do
  subject { build(:topping) }

  describe 'associations' do
    it { is_expected.to belong_to(:product) }
    it { is_expected.to have_many(:stock_toppings) }
    it { is_expected.to have_many(:stocks) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:key) }
    it { is_expected.to validate_presence_of(:value) }
    it { is_expected.to validate_uniqueness_of(:key).scoped_to(:value, :product_id) }

    describe '#price_change' do
      it { is_expected.to allow_value('+120.2').for(:price_change) }
      it { is_expected.not_to allow_value('125.1').for(:price_change) }
    end
  end
end
