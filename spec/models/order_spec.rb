require 'rails_helper'

RSpec.describe Order, type: :model do
  subject(:order) { build(:order) }

  describe 'associations' do
    it { is_expected.to belong_to(:payment) }
    it { is_expected.to belong_to(:user_location) }
    it { is_expected.to have_one(:purchase_cart).through(:payment) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:status) }
  end

  describe 'uuid' do
    before do
      order.uuid = nil

      VCR.use_cassette('geocoder_response', match_requests_on: %i[method host path]) do
        order.save
      end
    end

    it 'is generated on creation' do
      expect(order.uuid).not_to be_nil
    end
  end
end
