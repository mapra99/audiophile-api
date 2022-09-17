require 'rails_helper'

RSpec.describe Orders::StartOrder do
  subject(:starter) { described_class.new(payment: payment) }

  let(:user_location) do
    VCR.use_cassette('geocoder_response') do
      create(:user_location, location: create(:colpatria_tower_co))
    end
  end
  let(:cart_item1) { create(:purchase_cart_item) }
  let(:cart_item2) { create(:purchase_cart_item) }
  let(:purchase_cart) do
    create(:purchase_cart, user_location: user_location, purchase_cart_items: [cart_item1, cart_item2])
  end
  let(:payment) { create(:payment, purchase_cart: purchase_cart) }

  describe '#call' do
    subject(:result) { starter.call }

    before do
      allow(cart_item1).to receive(:reduce_stock_amount!).and_return(true)
      allow(cart_item2).to receive(:reduce_stock_amount!).and_return(true)
    end

    it 'creates a new order' do
      expect { starter.call }.to change(Order, :count).by(1)
    end
  end
end
