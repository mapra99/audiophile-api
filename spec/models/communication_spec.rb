require 'rails_helper'

RSpec.describe Communication, type: :model do
  subject { create(:communication) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:topic) }
  end

  describe 'associations' do
    it { is_expected.to have_one(:email_communication) }
    it { is_expected.to have_one(:twilio_verify_communication) }
  end
end
