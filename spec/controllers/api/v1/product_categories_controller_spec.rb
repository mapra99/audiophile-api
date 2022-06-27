require 'rails_helper'

RSpec.describe Api::V1::ProductCategoriesController, type: :controller do
  render_views

  describe '#index' do
    let(:product_categories) { create_list(:product_category, 2) }
    let(:builder_result) do
      instance_double('CollectionBuilder Result', success?: true, failure?: false, value!: product_categories)
    end
    let(:collection_builder) { instance_double(Admin::V1::ProductCategories::CollectionBuilder, call: builder_result) }

    before do
      allow(Api::V1::ProductCategories::CollectionBuilder).to receive(:new).and_return collection_builder

      request.headers['X-AUDIOPHILE-KEY'] = 'audiophile'
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
        instance_double('CollectionBuilder Result', success?: false, failure?: true, failure: { code: :internal_error })
      end

      it 'returns a 500 status' do
        expect(response.status).to eq 500
      end
    end

    describe 'when not authenticated' do
      before do
        request.headers['X-AUDIOPHILE-KEY'] = nil
        get :index, format: :json
      end

      it 'returns a 401 error' do
        expect(response.status).to eq 401
      end
    end
  end

  describe '#show' do
    let(:product_category) { create(:product_category) }
    let(:finder_result) do
      instance_double('Finder Result', success?: true, failure?: false, value!: product_category)
    end
    let(:finder) { instance_double(Api::V1::ProductCategories::Finder, call: finder_result) }

    before do
      allow(Api::V1::ProductCategories::Finder).to receive(:new).and_return finder

      request.headers['X-AUDIOPHILE-KEY'] = 'audiophile'
      get :show, format: :json, params: { slug: product_category.slug }
    end

    it 'calls the collection builder service' do
      expect(finder).to have_received(:call)
    end

    it 'returns a 200 status' do
      expect(response.status).to eq 200
    end

    describe 'when finder fails' do
      let(:finder_result) do
        instance_double('Finder Result', success?: false, failure?: true, failure: { code: :not_found })
      end

      it 'returns a 404 status' do
        expect(response.status).to eq 404
      end
    end

    describe 'when not authenticated' do
      before do
        request.headers['X-AUDIOPHILE-KEY'] = nil
        get :show, format: :json, params: { slug: product_category.slug }
      end

      it 'returns a 401 error' do
        expect(response.status).to eq 401
      end
    end
  end
end
