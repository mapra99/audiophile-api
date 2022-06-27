require 'rails_helper'

RSpec.describe Api::V1::ProductCategories::CollectionBuilder do
  subject { described_class.new }

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
