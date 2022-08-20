require 'rails_helper'

RSpec.describe Api::V1::Sessions::Creator do
  subject(:creator) { described_class.new(client_ip: client_ip) }

  let(:client_ip) { Faker::Internet.ip_v4_address }

  describe '#call' do
    subject(:result) { creator.call }

    describe 'when successful' do
      it 'creates a new session' do
        expect { result }.to change(Session, :count).by(1)
      end

      it 'returns the created session' do
        expect(result.value!).to eq(Session.last)
      end
    end

    describe 'when session could not be created' do
      let(:client_ip) { nil }

      it 'fails' do
        expect(result.failure?).to eq(true)
      end

      it 'returns an invalid session code' do
        expect(result.failure[:code]).to eq(:invalid_session)
      end
    end
  end
end
