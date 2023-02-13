require 'rails_helper'

RSpec.describe Sessions::OldSessionsRemover do
  subject(:remover) { described_class.new }

  describe '#call' do
    before do
      create_list(:session, 2, updated_at: 2.months.ago)
      create_list(:session, 4)
    end

    it 'removes old sessions' do
      expect { remover.call }.to change(Session, :count).from(6).to(4)
    end

    describe 'when old sessions have purchase carts' do
      before do
        session = create(:session, updated_at: 2.months.ago)
        create(:purchase_cart, session: session)
      end

      it 'does not remove those' do
        expect { remover.call }.to change(Session, :count).from(7).to(5)
      end
    end
  end
end
