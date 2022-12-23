require 'rails_helper'

RSpec.describe Admin::V1::ProductCategoriesController, type: :controller do
  render_views

  describe '#create' do
    let(:payload) do
      {
        name: 'Headphonez',
        image: fixture_file_upload('product_image.png', 'image/png')
      }
    end
    let(:created_category) { create(:product_category) }
    let(:creator_result) do
      instance_double('Creator Result', success?: true, failure?: false, value!: created_category)
    end
    let(:creator) { instance_double(Admin::V1::ProductCategories::Creator, call: creator_result) }

    before do
      allow(Admin::V1::ProductCategories::Creator).to receive(:new).and_return creator

      request.headers['X-ADMIN-KEY'] = 'admin'
      post :create, format: :json, params: payload
    end

    it 'calls the collection creator' do
      expect(creator).to have_received(:call)
    end

    it 'returns a 200 status' do
      expect(response.status).to eq 200
    end

    describe 'when creator fails due to internal error' do
      let(:creator_result) do
        instance_double('Creator Result', success?: false, failure?: true, failure: { code: :internal_error })
      end

      it 'returns a 500 status' do
        expect(response.status).to eq 500
      end
    end

    describe 'when creator fails due to validation error' do
      let(:creator_result) do
        instance_double('Creator Result', success?: false, failure?: true,
                                          failure: { code: :invalid_product_category, message: ['Error'] })
      end

      it 'returns a 422 status' do
        expect(response.status).to eq 422
      end
    end

    describe 'when creator fails due to product category not saved' do
      let(:creator_result) do
        instance_double('Creator Result', success?: false, failure?: true,
                                          failure: { code: :product_category_not_saved })
      end

      it 'returns a 500 status' do
        expect(response.status).to eq 500
      end
    end

    describe 'when not authenticated' do
      before do
        request.headers['X-ADMIN-KEY'] = nil
        post :create, format: :json, params: payload
      end

      it 'returns a 401 error' do
        expect(response.status).to eq 401
      end
    end
  end

  describe '#index' do
    let(:product_categories) { create_list(:product_category, 2) }
    let(:builder_result) do
      instance_double('CollectionBuilder Result', success?: true, failure?: false, value!: product_categories)
    end
    let(:collection_builder) { instance_double(Admin::V1::ProductCategories::CollectionBuilder, call: builder_result) }

    before do
      allow(Admin::V1::ProductCategories::CollectionBuilder).to receive(:new).and_return collection_builder

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
        instance_double('CollectionBuilder Result', success?: false, failure?: true, failure: { code: :internal_error })
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

  describe '#update' do
    let(:payload) do
      {
        id: product_category.id,
        name: 'Headphonez',
        image: fixture_file_upload('product_image.png', 'image/png')
      }
    end
    let(:product_category) { create(:product_category) }
    let(:updater_result) do
      instance_double('Creator Result', success?: true, failure?: false, value!: product_category)
    end
    let(:updater) { instance_double(Admin::V1::ProductCategories::Updater, call: updater_result) }

    before do
      allow(Admin::V1::ProductCategories::Updater).to receive(:new).and_return updater

      request.headers['X-ADMIN-KEY'] = 'admin'
      put :update, format: :json, params: payload
    end

    it 'calls the updater' do
      expect(updater).to have_received(:call)
    end

    it 'returns a 200 status' do
      expect(response.status).to eq 200
    end

    describe 'when updater fails due to internal error' do
      let(:updater_result) do
        instance_double('Updater Result', success?: false, failure?: true, failure: { code: :internal_error })
      end

      it 'returns a 500 status' do
        expect(response.status).to eq 500
      end
    end

    describe 'when updater fails due to category not found' do
      let(:updater_result) do
        instance_double('Updater Result', success?: false, failure?: true,
                                          failure: { code: :category_not_found })
      end

      it 'returns a 400 status' do
        expect(response.status).to eq 400
      end
    end

    describe 'when not authenticated' do
      before do
        request.headers['X-ADMIN-KEY'] = nil
        put :update, format: :json, params: payload
      end

      it 'returns a 401 error' do
        expect(response.status).to eq 401
      end
    end
  end
end
