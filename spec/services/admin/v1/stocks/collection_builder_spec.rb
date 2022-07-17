require 'rails_helper'

RSpec.describe Admin::V1::Stocks::CollectionBuilder do
  subject { described_class.new }

  describe 'when no filters' do
    let(:result) { subject.call }

    before do
      create_list(:stock, 2)
    end

    it 'succeeds' do
      expect(result.success?).to eq true
    end

    it 'returns all stocks' do
      expect(result.value!.count).to eq 2
    end
  end

  describe 'when using filters' do
    describe 'product filter' do
      let(:product) { create(:product) }
      let(:result) { subject.call(filters: { product_id: product.id }) }

      before do
        create_list(:stock, 2, product: product)
      end

      it 'succeeds' do
        expect(result.success?).to eq true
      end

      it 'returns stocks that belong to the given product' do
        expect(result.value!.count).to eq 2
      end
    end
  end

  describe 'when an error is raised' do
    let(:result) { subject.call }

    before do
      allow(Stock).to receive(:all).and_raise(StandardError, 'ERROR')
    end

    it 'fails' do
      expect(result.failure?).to eq true
    end

    it 'provides an error code' do
      expect(result.failure).to eq({ code: :internal_error })
    end
  end
end
