require 'rails_helper'

RSpec.describe Communications::EmailSenderJob, type: :job do
  let(:template_id) { SecureRandom.hex }
  let(:template_data) { { variable: '123' } }
  let(:sender) { EmailCommunication::SENDERS.sample }
  let(:recipient) { Faker::Internet.email }
  let(:topic) { Communication::TOPICS.sample }

  let(:email_sender) { instance_double(Communications::EmailSender, call: true) }

  before do
    allow(Communications::EmailSender).to receive(:new).and_return(email_sender)

    described_class.perform_now(
      topic: topic,
      sender: sender,
      recipient: recipient,
      template_id: template_id,
      template_data: template_data
    )
  end

  it 'calls the email sender service' do
    expect(email_sender).to have_received(:call)
  end
end
