require 'rails_helper'

RSpec.describe EmailCommunication, type: :model do
  subject { create(:email_communication) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:sender) }
    it { is_expected.to validate_presence_of(:recipient) }
    it { is_expected.to validate_presence_of(:template_id) }
    it { is_expected.to validate_presence_of(:template_data) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:communication) }
  end
end
