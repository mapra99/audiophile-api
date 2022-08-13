FactoryBot.define do
  factory :access_token do
    association :user
    association :verification_code
    expires_at { 1.week.from_now }
    status { AccessToken::STATUS_TYPES.sample }
    token { SecureRandom.hex }
  end
end
