require 'rails_helper'

RSpec.describe Api::V1::Products::CollectionBuilder do
  subject { described_class.new }

  describe 'when no filters' do
    let(:result) { subject.call }

    before do
      create_list(:product, 2)
    end

    it 'succeeds' do
      expect(result.success?).to eq true
    end

    it 'returns all products' do
      expect(result.value!.count).to eq 2
    end
  end

  describe 'when using filters' do
    describe 'category filter' do
      let(:category1) { create(:product_category) }
      let(:category2) { create(:product_category) }
      let(:result) { subject.call(filters: { category_ids: [category1.id, category2.id] }) }

      before do
        create_list(:product, 2)
        create_list(:product, 2, product_category: category1)
        create_list(:product, 2, product_category: category2)
      end

      it 'succeeds' do
        expect(result.success?).to eq true
      end

      it 'returns products that belong to the given categories' do
        expect(result.value!.count).to eq 4
      end
    end

    describe 'featured filter' do
      let(:result) { subject.call(filters: { featured: true }) }

      before do
        create_list(:product, 2)
        create_list(:product, 5, featured: true)
      end

      it 'succeeds' do
        expect(result.success?).to eq true
      end

      it 'returns only featured products' do
        expect(result.value!.count).to eq 5
      end
    end

    describe 'contents filter' do
      let(:result) { subject.call(filters: { content: { foo: 'bar' } }) }

      before do
        create_list(:product, 2)
        product = create(:product)
        create(:product_content, product: product, key: 'foo', value: 'bar')
      end

      it 'succeeds' do
        expect(result.success?).to eq true
      end

      it 'returns the only product with the given content' do
        expect(result.value!.count).to eq(1)
      end
    end

    describe 'stock available filter' do
      let(:result) { subject.call(filters: { stock_available: 'true' }) }

      before do
        create_list(:product, 2)
        product = create(:product)
        create(:stock, product: product, quantity: 1)
      end

      it 'succeeds' do
        expect(result.success?).to eq true
      end

      it 'returns the only product with stocks available' do
        expect(result.value!.count).to eq(1)
      end
    end
  end

  describe 'when an error is raised' do
    let(:result) { subject.call }

    before do
      allow(Product).to receive(:all).and_raise(StandardError, 'ERROR')
    end

    it 'fails' do
      expect(result.failure?).to eq true
    end

    it 'provides an error code' do
      expect(result.failure).to eq({ code: :internal_error })
    end
  end
end
