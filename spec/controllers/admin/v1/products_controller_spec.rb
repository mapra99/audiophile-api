require 'rails_helper'

RSpec.describe Admin::V1::ProductsController, type: :controller do
  render_views

  describe '#index' do
    let(:products) { create_list(:product, 2) }
    let(:builder_result) do
      instance_double('CollectionBuilder Result', success?: true, failure?: false, value!: products)
    end
    let(:collection_builder) { instance_double(Admin::V1::Products::CollectionBuilder, call: builder_result) }

    before do
      allow(Admin::V1::Products::CollectionBuilder).to receive(:new).and_return collection_builder

      request.headers['X-ADMIN-KEY'] = 'admin'
      get :index, format: :json
    end

    it 'calls the collection builder service' do
      expect(collection_builder).to have_received(:call)
    end

    it 'returns a 200 status' do
      expect(response.status).to eq 200
    end

    describe 'when builder fails' do
      let(:builder_result) do
        instance_double('CollectionBuilder Result', success?: false, failure?: true, failure: :internal_error)
      end

      it 'returns a 500 status' do
        expect(response.status).to eq 500
      end
    end

    describe 'when not authenticated' do
      before do
        request.headers['X-ADMIN-KEY'] = nil
        get :index, format: :json
      end

      it 'returns a 401 error' do
        expect(response.status).to eq 401
      end
    end
  end
end
