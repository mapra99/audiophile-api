FactoryBot.define do
  factory :verification_code do
    association :user
    expires_at { 15.minutes.from_now }
    status { VerificationCode::STATUS_TYPES.sample }
    code { format('%06d', rand(0..999_999)) }
  end
end
