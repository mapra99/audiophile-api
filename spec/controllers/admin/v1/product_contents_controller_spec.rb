require 'rails_helper'

RSpec.describe Admin::V1::ProductContentsController, type: :controller do
  render_views

  describe '#create' do
    let(:product) { create(:product) }
    let(:payload) do
      {
        product_id: product.id,
        key: 'main_thumbnail',
        content: content
      }
    end
    let(:content) { fixture_file_upload('product_image.png', 'image/png') }
    let(:created_content) { create(:attachment_product_content) }
    let(:creator_result) do
      instance_double('Creator Result', success?: true, failure?: false, value!: created_content)
    end
    let(:creator) { instance_double(Admin::V1::ProductContents::Creator, call: creator_result) }

    before do
      allow(Admin::V1::ProductContents::Creator).to receive(:new).and_return creator

      request.headers['X-ADMIN-KEY'] = 'admin'
      post :create, format: :json, params: payload
    end

    it 'calls the collection creator' do
      expect(creator).to have_received(:call)
    end

    it 'returns a 200 status' do
      expect(response.status).to eq 200
    end

    describe 'when passing multiple files as content' do
      let(:content) do
        [
          fixture_file_upload('product_image.png', 'image/png'),
          fixture_file_upload('product_image.png', 'image/png')
        ]
      end

      it 'returns a 200 status' do
        expect(response.status).to eq 200
      end
    end

    describe 'when creator fails due to internal error' do
      let(:creator_result) do
        instance_double('Creator Result', success?: false, failure?: true, failure: { code: :internal_error })
      end

      it 'returns a 500 status' do
        expect(response.status).to eq 500
      end
    end

    describe 'when creator fails due to product not found' do
      let(:creator_result) do
        instance_double('Creator Result', success?: false, failure?: true, failure: { code: :product_not_found })
      end

      it 'returns a 400 status' do
        expect(response.status).to eq 400
      end
    end

    describe 'when creator fails due to validation error' do
      let(:creator_result) do
        instance_double('Creator Result', success?: false, failure?: true,
                                          failure: { code: :invalid_product_content, message: ['Error'] })
      end

      it 'returns a 422 status' do
        expect(response.status).to eq 422
      end
    end

    describe 'when creator fails due to content not saved' do
      let(:creator_result) do
        instance_double('Creator Result', success?: false, failure?: true,
                                          failure: { code: :product_content_not_saved })
      end

      it 'returns a 500 status' do
        expect(response.status).to eq 500
      end
    end

    describe 'when creator fails due to wrong params' do
      let(:creator_result) do
        instance_double('Creator Result', success?: false, failure?: true, failure: { code: :wrong_params })
      end

      it 'returns a 500 status' do
        expect(response.status).to eq 400
      end
    end
  end
end
