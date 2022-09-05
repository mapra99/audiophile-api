require 'rails_helper'

RSpec.describe Payments::Stripe::PaymentIntentCreator do
  subject(:creator) { described_class.new(amount: amount) }

  let(:amount) { 14.50 }

  describe '#call' do
    it 'calls stripe api to create a payment intent' do
      VCR.use_cassette('stripe_payment_intent') do
        creator.call
        expect(creator.payment_intent).not_to be_nil
      end
    end
  end
end
