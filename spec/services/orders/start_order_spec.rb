require 'rails_helper'

RSpec.describe Orders::StartOrder do
  subject(:starter) { described_class.new(payment: payment) }

  let(:user_location) { create(:user_location, location: create(:colpatria_tower_co)) }
  let(:purchase_cart) do
    create(:purchase_cart, user_location: user_location, purchase_cart_items: create_list(:purchase_cart_item, 10))
  end
  let(:payment) { create(:payment, purchase_cart: purchase_cart0) }

  # describe '#call' do
  #   subject(:result) { starter.call }

  #   before do
  #     allow_any_instance_of(PurchaseCartItem).to receive(:reduce_stock_amount!)
  #   end

  #   it ''
  # end
end
