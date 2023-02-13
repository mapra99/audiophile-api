require 'rails_helper'

RSpec.describe Session, type: :model do
  subject(:session) { build(:session) }

  describe 'associations' do
    it { is_expected.to have_many(:purchase_carts) }
    it { is_expected.to belong_to(:user).optional }
    it { is_expected.to have_many(:page_views).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:ip_address) }
  end

  describe '.more_than_one_month_old' do
    subject(:result) { described_class.more_than_one_month_old }

    let(:old_sessions) { create_list(:session, 2, updated_at: 5.months.ago) }

    before do
      old_sessions
      create_list(:session, 2)
    end

    it 'returns all old sessions' do
      expect(result).to eq(old_sessions)
    end
  end

  describe '.with_no_purchase_carts' do
    subject(:result) { described_class.with_no_purchase_carts }

    let(:sessions) { create_list(:session, 3) }

    before do
      create(:purchase_cart, session: sessions.last)
    end

    it 'returns the sessions without purchase cart' do
      expect(result).to eq(sessions[0..1])
    end
  end
end
