require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:phone) }
    it { is_expected.to validate_uniqueness_of(:email) }

    describe 'email format' do
      it { is_expected.to allow_value('email@addresse.foo').for(:email) }
      it { is_expected.not_to allow_value('foo').for(:email) }
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:email_communications) }
    it { is_expected.to have_many(:verification_codes) }
    it { is_expected.to have_many(:access_tokens) }
    it { is_expected.to have_many(:user_locations) }
    it { is_expected.to have_many(:locations) }
    it { is_expected.to have_many(:sessions) }
    it { is_expected.to have_many(:purchase_carts) }
  end
end
