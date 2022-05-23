require 'rails_helper'

RSpec.describe ProductCategory, type: :model do
  subject { build(:product_category) }

  describe 'associations' do
    it { is_expected.to have_one_attached(:image) }
    it { is_expected.to have_many(:products) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end
end
