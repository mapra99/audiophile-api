FactoryBot.define do
  factory :email_communication do
    association :communication

    sender { EmailCommunication::SENDERS.sample }
    recipient { Faker::Internet.email }
    template_id { SecureRandom.hex }
    template_data do
      {
        variable: '123'
      }
    end
  end
end
