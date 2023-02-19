class VerificationCode < ApplicationRecord
  belongs_to :user
  has_secure_password :code
  has_one :access_token, dependent: :destroy

  validates :expires_at, :status, presence: true
  validates_with Validators::CodeStatusValidator

  STARTED = 'started'.freeze
  USED = 'used'.freeze
  EXPIRED = 'expired'.freeze

  STATUS_TYPES = [
    STARTED,
    USED,
    EXPIRED
  ].freeze

  EMAIL_CHANNEL = 'email'.freeze
  SMS_CHANNEL = 'sms'.freeze

  CHANNELS = [
    EMAIL_CHANNEL,
    SMS_CHANNEL
  ].freeze

  scope :started, -> { where(status: STARTED) }
end
