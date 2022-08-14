require 'rails_helper'

RSpec.describe Api::V1::AuthController, type: :controller do
  render_views

  describe '#signup' do
    let(:payload) do
      {
        name: 'Jhon Doe',
        email: 'jhon.doe+20220814-2@gmail.com',
        phone: '1112223333'
      }
    end

    let(:signup_result) do
      instance_double('Signup Result', success?: true, failure?: false, value!: nil)
    end
    let(:signup) { instance_double(Api::V1::Auth::Signup, call: signup_result) }

    before do
      allow(Api::V1::Auth::Signup).to receive(:new).and_return signup

      request.headers['X-AUDIOPHILE-KEY'] = 'audiophile'
      post :signup, format: :json, params: payload
    end

    it 'calls the collection creator' do
      expect(signup).to have_received(:call)
    end

    it 'returns a 204 status' do
      expect(response.status).to eq 204
    end

    describe 'when signup fails due to internal error' do
      let(:signup_result) do
        instance_double('Signup Result', success?: false, failure?: true, failure: { code: :internal_error })
      end

      it 'returns a 500 status' do
        expect(response.status).to eq 500
      end
    end

    describe 'when signup fails due to invalid user' do
      let(:signup_result) do
        instance_double('Signup Result', success?: false, failure?: true,
                                         failure: { code: :invalid_user, message: 'Validation failed' })
      end

      it 'returns a 422 status' do
        expect(response.status).to eq 422
      end
    end

    describe 'when signup fails due to code not created' do
      let(:signup_result) do
        instance_double('Signup Result', success?: false, failure?: true,
                                         failure: { code: :code_not_created, message: 'Error' })
      end

      it 'returns a 422 status' do
        expect(response.status).to eq 422
      end
    end
  end

  describe '#login' do
    let(:payload) do
      { email: user_email }
    end

    let(:user) { create(:user) }
    let(:user_email) { user.email }

    let(:login_result) do
      instance_double('Login Result', success?: true, failure?: false, value!: nil)
    end
    let(:login) { instance_double(Api::V1::Auth::Login, call: login_result) }

    before do
      allow(Api::V1::Auth::Login).to receive(:new).and_return login

      request.headers['X-AUDIOPHILE-KEY'] = 'audiophile'
      post :login, format: :json, params: payload
    end

    it 'calls the login action' do
      expect(login).to have_received(:call)
    end

    it 'returns a 204 status' do
      expect(response.status).to eq 204
    end

    describe 'when login fails due to internal error' do
      let(:login_result) do
        instance_double('Login Result', success?: false, failure?: true, failure: { code: :internal_error })
      end

      it 'returns a 500 status' do
        expect(response.status).to eq 500
      end
    end

    describe 'when login fails due to user not found' do
      let(:login_result) do
        instance_double('Login Result', success?: false, failure?: true,
                                        failure: { code: :user_not_found, message: 'Not found' })
      end

      it 'returns a 400 status' do
        expect(response.status).to eq 400
      end
    end

    describe 'when login fails due to code not created' do
      let(:login_result) do
        instance_double('Login Result', success?: false, failure?: true,
                                        failure: { code: :code_not_created, message: 'Error' })
      end

      it 'returns a 422 status' do
        expect(response.status).to eq 422
      end
    end
  end

  describe '#confirmation' do
    let(:payload) do
      {
        email: user_email,
        code: code
      }
    end

    let(:user) { create(:user) }
    let(:user_email) { user.email }

    let(:code) { '000000' }
    let(:verification_code) { create(:verification_code, user: user, code: code) }
    let(:access_token) { create(:access_token, user: user, verification_code: verification_code) }

    let(:confirmation_result) do
      instance_double('Confirmation Result', success?: true, failure?: false, value!: access_token)
    end
    let(:confirmation) { instance_double(Api::V1::Auth::Confirmation, call: confirmation_result) }

    before do
      allow(Api::V1::Auth::Confirmation).to receive(:new).and_return confirmation

      request.headers['X-AUDIOPHILE-KEY'] = 'audiophile'
      post :confirmation, format: :json, params: payload
    end

    it 'calls the confirmation action' do
      expect(confirmation).to have_received(:call)
    end

    it 'returns a 200 status' do
      expect(response.status).to eq 200
    end

    describe 'when confirmation fails due to internal error' do
      let(:confirmation_result) do
        instance_double('Confirmation Result', success?: false, failure?: true, failure: { code: :internal_error })
      end

      it 'returns a 500 status' do
        expect(response.status).to eq 500
      end
    end

    describe 'when confirmation fails due to user not found' do
      let(:confirmation_result) do
        instance_double('Confirmation Result', success?: false, failure?: true,
                                               failure: { code: :user_not_found, message: 'Not found' })
      end

      it 'returns a 400 status' do
        expect(response.status).to eq 400
      end
    end

    describe 'when confirmation fails due to no started codes found' do
      let(:confirmation_result) do
        instance_double('Confirmation Result', success?: false, failure?: true,
                                               failure: { code: :no_started_codes, message: 'Error' })
      end

      it 'returns a 422 status' do
        expect(response.status).to eq 422
      end
    end

    describe 'when confirmation fails due to incorrect code' do
      let(:confirmation_result) do
        instance_double('Confirmation Result', success?: false, failure?: true,
                                               failure: { code: :incorrect_code, message: 'Error' })
      end

      it 'returns a 400 status' do
        expect(response.status).to eq 400
      end
    end

    describe 'when confirmation fails due to token invalid' do
      let(:confirmation_result) do
        instance_double('Confirmation Result', success?: false, failure?: true,
                                               failure: { code: :invalid_token, message: 'Error' })
      end

      it 'returns a 422 status' do
        expect(response.status).to eq 422
      end
    end
  end

  describe '#logout' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, user: user, status: AccessToken::ACTIVE) }

    let(:logout_result) do
      instance_double('Logout Result', success?: true, failure?: false, value!: nil)
    end
    let(:logout) { instance_double(Api::V1::Auth::Logout, call: logout_result) }

    before do
      allow(Api::V1::Auth::Logout).to receive(:new).and_return logout

      request.headers['X-AUDIOPHILE-KEY'] = 'audiophile'
      request.headers['Authorization'] = "Bearer #{access_token.token}"
      post :logout, format: :json
    end

    it 'calls the logout action' do
      expect(logout).to have_received(:call)
    end

    it 'returns a 204 status' do
      expect(response.status).to eq 204
    end

    describe 'when logout fails due to internal error' do
      let(:logout_result) do
        instance_double('Logout Result', success?: false, failure?: true, failure: { code: :internal_error })
      end

      it 'returns a 500 status' do
        expect(response.status).to eq 500
      end
    end
  end
end
