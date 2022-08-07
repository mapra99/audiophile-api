require 'rails_helper'

RSpec.describe Communication, type: :model do
  subject { create(:communication) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:topic) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:email_communications) }
  end
end
