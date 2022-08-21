require 'rails_helper'

RSpec.describe Location, type: :model do
  subject(:location) { build(:location) }

  describe 'associations' do
    it { is_expected.to have_many(:user_locations) }
    it { is_expected.to have_many(:users) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:street_address) }
    it { is_expected.to validate_presence_of(:city) }
    it { is_expected.to validate_presence_of(:country) }
    it { is_expected.to validate_presence_of(:postal_code) }
  end
end
