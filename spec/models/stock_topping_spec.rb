require 'rails_helper'

RSpec.describe StockTopping, type: :model do
  subject { build(:stock_topping) }

  describe 'associations' do
    it { is_expected.to belong_to(:stock) }
    it { is_expected.to belong_to(:topping) }
  end
end
