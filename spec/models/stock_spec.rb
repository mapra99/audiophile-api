require 'rails_helper'

RSpec.describe Stock, type: :model do
  subject(:stock) { build(:stock) }

  describe 'associations' do
    it { is_expected.to belong_to(:product) }
    it { is_expected.to have_many(:stock_toppings) }
    it { is_expected.to have_many(:toppings) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:quantity) }
  end

  describe 'uuid' do
    before do
      stock.uuid = nil
      stock.save
    end

    it 'is generated on creation' do
      expect(stock.uuid).not_to be_nil
    end
  end
end
