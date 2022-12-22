require 'rails_helper'

RSpec.describe Api::V1::PageViews::Creator do
  subject(:creator) do
    described_class.new(session: session, params: { page_path: '/something', query_params: '?test=true' })
  end

  let(:session) { create(:session) }

  describe '#call' do
    subject(:result) { creator.call }

    describe 'when successful' do
      it 'creates a new page view' do
        expect { result }.to change(PageView, :count).by(1)
      end

      it 'returns the created page view' do
        expect(result.value!).to eq(PageView.last)
      end
    end

    describe 'when page view could not be created' do
      let(:session) { nil }

      it 'fails' do
        expect(result.failure?).to eq(true)
      end

      it 'returns an internal error code' do
        expect(result.failure[:code]).to eq(:internal_error)
      end
    end
  end
end
