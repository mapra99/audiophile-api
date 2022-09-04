require 'rails_helper'

RSpec.describe Api::V1::Locations::CollectionBuilder do
  subject(:collection_builder) { described_class.new(user: user) }

  let(:location) { create(:colpatria_tower_co) }
  let(:user) { create(:user) }
  let(:user_location) { create(:user_location, location: location, user: user) }

  describe '#call' do
    subject(:result) { collection_builder.call }

    describe 'when successful' do
      it 'succeeds' do
        expect(result.success?).to eq(true)
      end

      it 'returns the user locations' do
        expect(result.value!).to eq(user.user_locations)
      end
    end
  end
end
