FactoryBot.define do
  factory :communication do
    topic { Communication::TOPICS.sample }
  end
end
