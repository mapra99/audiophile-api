require 'rails_helper'

RSpec.describe AccessToken, type: :model do
  subject(:token) { build(:access_token) }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:verification_code) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:token) }
    it { is_expected.to validate_presence_of(:expires_at) }
    it { is_expected.to validate_presence_of(:status) }
  end
end
