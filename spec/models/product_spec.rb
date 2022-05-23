require 'rails_helper'

RSpec.describe Product, type: :model do
  subject { build(:product) }

  describe 'associations' do
    it { is_expected.to have_one_attached(:image) }
    it { is_expected.to have_many(:product_contents) }
    it { is_expected.to belong_to(:product_category) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_presence_of(:base_price) }
  end
end
