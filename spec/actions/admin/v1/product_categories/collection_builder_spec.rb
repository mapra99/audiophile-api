require 'rails_helper'

RSpec.describe Admin::V1::ProductCategories::CollectionBuilder do
  subject { described_class.new }

  describe 'when no filters' do
    let(:result) { subject.call }

    before do
      create_list(:product_category, 2)
    end

    it 'succeeds' do
      expect(result.success?).to eq true
    end

    it 'returns all product categories' do
      expect(result.value!.count).to eq 2
    end
  end

  describe 'when using filters' do
    describe 'name filter' do
      let(:result) { subject.call(filters: { name: 'some cool p' }) }

      before do
        create_list(:product_category, 2)
        create(:product_category, name: 'some cool products')
      end

      it 'succeeds' do
        expect(result.success?).to eq true
      end

      it 'returns only featured products' do
        expect(result.value!.count).to eq 1
      end
    end
  end

  describe 'when an error is raised' do
    let(:result) { subject.call }

    before do
      allow(ProductCategory).to receive(:all).and_raise(StandardError, 'ERROR')
    end

    it 'fails' do
      expect(result.failure?).to eq true
    end

    it 'provides an error code' do
      expect(result.failure).to eq({ code: :internal_error })
    end
  end
end
