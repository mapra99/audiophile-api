class VerificationCode < ApplicationRecord
  belongs_to :user
  has_secure_password :code

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

  scope :started, -> { where(status: STARTED) }
end
