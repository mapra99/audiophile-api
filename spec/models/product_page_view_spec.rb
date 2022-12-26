require 'rails_helper'

RSpec.describe ProductPageView, type: :model do
  subject(:product_page_view) { build(:product_page_view) }

  describe 'associations' do
    it { is_expected.to belong_to(:product) }
    it { is_expected.to belong_to(:page_view) }
  end
end
