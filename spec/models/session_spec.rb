require 'rails_helper'

RSpec.describe Session, type: :model do
  subject(:session) { build(:session) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:ip_address) }
  end
end
