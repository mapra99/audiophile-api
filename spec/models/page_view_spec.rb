require 'rails_helper'

RSpec.describe PageView do
  subject(:page_view) { build(:page_view) }

  describe 'associations' do
    it { is_expected.to belong_to(:session) }
  end
end
