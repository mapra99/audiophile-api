require 'rails_helper'

RSpec.describe PaymentEvent, type: :model do
  subject { build(:payment_event, :created_intent) }

  describe 'associations' do
    it { is_expected.to belong_to(:payment) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:event_name) }
    it { is_expected.to validate_presence_of(:raw_data) }
  end
end
