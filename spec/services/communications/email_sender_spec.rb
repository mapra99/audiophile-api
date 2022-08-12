require 'rails_helper'

describe Communications::EmailSender do
  subject(:email_sender) do
    described_class.new(
      template_id: template_id,
      template_data: template_data,
      sender: sender,
      recipient: recipient,
      topic: topic
    )
  end

  let(:template_id) { SecureRandom.hex }
  let(:template_data) { { variable: '123' } }
  let(:sender) { EmailCommunication::SENDERS.sample }
  let(:recipient) { Faker::Internet.email }
  let(:topic) { Communication::TOPICS.sample }

  describe '#call' do
    let(:sendgrid_personalization) do
      instance_double(
        SendGrid::Personalization,
        {
          add_to: true,
          add_dynamic_template_data: true
        }
      )
    end

    let(:sendgrid_email) { instance_double(SendGrid::Email, {}) }
    let(:sendgrid_mail) do
      instance_double(
        SendGrid::Mail,
        {
          "from=": true,
          "template_id=": true,
          add_personalization: true
        }
      )
    end
    let(:sendgrid_api_response) { instance_double('SendGrid API Response', status_code: '200', body: '') }

    # rubocop:disable RSpec/MessageChain
    before do
      allow(SendGrid::Personalization).to receive(:new).and_return(sendgrid_personalization)
      allow(SendGrid::Email).to receive(:new).and_return(sendgrid_email)
      allow(SendGrid::Mail).to receive(:new).and_return(sendgrid_mail)
      allow(SendGrid::API).to receive_message_chain('new.client.mail._.post').and_return(sendgrid_api_response)
    end
    # rubocop:enable RSpec/MessageChain

    describe 'when valid params' do
      before do
        email_sender.call
      end

      it 'creates a communication record' do
        expect(email_sender.communication).to eq(Communication.last)
      end

      it 'creates an email communication record' do
        expect(email_sender.email_communication).to eq(EmailCommunication.last)
      end

      it 'sends the email through sendgrid' do
        expect(SendGrid::Mail).to have_received(:new)
      end
    end

    describe 'when topic is not a valid one' do
      let(:topic) { 'asdads' }

      it 'raises an InvalidTopic error' do
        expect { email_sender.call }.to raise_error(Communications::InvalidTopic)
      end
    end

    describe 'when sender is not a valid one' do
      let(:sender) { 'test@example.com' }

      it 'raises an InvalidSender error' do
        expect { email_sender.call }.to raise_error(Communications::InvalidSender)
      end
    end

    describe 'when api call returns an error status code' do
      let(:sendgrid_api_response) { instance_double('SendGrid API Response', status_code: '400', body: 'Error') }

      it 'raises an EmailNotSent error' do
        expect { email_sender.call }.to raise_error(Communications::EmailNotSent)
      end
    end

    describe 'when api call fails unexpectedly' do
      # rubocop:disable RSpec/MessageChain
      before do
        allow(SendGrid::API).to receive_message_chain('new.client.mail._.post').and_raise(StandardError.new('Error'))
      end
      # rubocop:enable RSpec/MessageChain

      it 'raises an EmailNotSent error' do
        expect { email_sender.call }.to raise_error(Communications::EmailNotSent)
      end
    end
  end
end
