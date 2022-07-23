require 'rails_helper'

RSpec.describe Admin::V1::Stocks::Creator do
  subject(:creator) { described_class.new(params: params) }

  let(:product) { create(:product) }
  let(:product_id) { product.id }
  let(:quantity) { 5 }
  let(:params) do
    {
      product_id: product_id,
      quantity: quantity,
      toppings: [
        {
          key: 'color',
          value: 'blue',
          price_change: '+100'
        }, {
          key: 'size',
          value: 'L',
          price_change: '+10'
        }
      ]
    }
  end

  describe '#call' do
    subject(:result) { creator.call }

    it 'succeeds' do
      expect(result.success?).to eq(true)
    end

    it 'creates a new stock' do
      expect { creator.call }.to change(Stock, :count).by(1)
    end

    it 'creates the new toppings' do
      expect { creator.call }.to change(Topping, :count).by(2)
    end

    it 'creates the new stock_toppings' do
      expect { creator.call }.to change(StockTopping, :count).by(2)
    end

    describe 'the new stock' do
      let(:new_stock) { creator.stock }

      before do
        creator.call
      end

      it 'has a quantity set by the params' do
        expect(new_stock.quantity).to eq(params[:quantity])
      end

      it 'has a product id per the params' do
        expect(new_stock.product.id).to eq(params[:product_id])
      end

      it 'has the toppings associated' do
        expect(new_stock.toppings.count).to eq(2)
      end
    end

    describe "when product is't found" do
      let(:product_id) { 'something' }

      it 'returns a failure' do
        expect(result.failure?).to eq(true)
      end

      it 'returns the right error code' do
        expect(result.failure[:code]).to eq(:product_not_found)
      end
    end

    describe 'when there are toppings with the same key name' do
      let(:params) do
        {
          product_id: product_id,
          quantity: 5,
          toppings: [
            {
              key: 'color',
              value: 'blue',
              price_change: '+100'
            }, {
              key: 'color',
              value: 'orange',
              price_change: '+10'
            }
          ]
        }
      end

      it 'does not create a new stock' do
        expect { creator.call }.not_to change(Stock, :count)
      end

      it 'returns a failure' do
        expect(result.failure?).to eq(true)
      end

      it 'returns the right error code' do
        expect(result.failure[:code]).to eq(:invalid_toppings)
      end
    end

    describe 'when there is already a stock with the same toppings keys and values' do
      before do
        stock = create(:stock, product: product)
        create(:topping, key: 'color', value: 'blue', stocks: [stock], product: product)
        create(:topping, key: 'size', value: 'L', stocks: [stock], product: product)
      end

      it 'does not create a new stock' do
        expect { creator.call }.not_to change(Stock, :count)
      end

      it 'returns a failure' do
        expect(result.failure?).to eq(true)
      end

      it 'returns the right error code' do
        expect(result.failure[:code]).to eq(:invalid_toppings)
      end
    end

    describe 'when service failes due to unhandled error' do
      before do
        allow(Stock).to receive(:new).and_raise(StandardError, 'ERROR MESSAGE')
      end

      it 'returns a failure' do
        expect(result.failure?).to eq(true)
      end

      it 'returns internal_error as failure code' do
        expect(result.failure[:code]).to eq(:internal_error)
      end
    end

    describe 'when stock could not be saved' do
      # rubocop:disable RSpec/AnyInstance
      before do
        allow_any_instance_of(Stock).to receive(:save!).and_raise(ActiveRecord::RecordNotSaved)
      end
      # rubocop:enable RSpec/AnyInstance

      it 'returns a failure' do
        expect(result.failure?).to eq(true)
      end

      it 'returns the right error code' do
        expect(result.failure[:code]).to eq(:stock_not_saved)
      end
    end

    describe 'when stock does not have quantity present' do
      let(:quantity) { nil }

      it 'returns a failure' do
        expect(result.failure?).to eq(true)
      end

      it 'returns the right error code' do
        expect(result.failure[:code]).to eq(:invalid_stock)
      end
    end
  end
end
