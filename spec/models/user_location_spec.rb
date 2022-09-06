require 'rails_helper'

RSpec.describe UserLocation, type: :model do
  subject(:user_location) { build(:user_location) }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:location) }
    it { is_expected.to have_many(:orders).dependent(:nullify) }
  end
end
