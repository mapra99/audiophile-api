require 'rails_helper'

RSpec.describe ProductRecommendation, type: :model do
  subject(:recommendation) { build(:product_recommendation) }

  describe 'associations' do
    it { is_expected.to belong_to(:product) }
    it { is_expected.to belong_to(:recommendation) }
  end
end
