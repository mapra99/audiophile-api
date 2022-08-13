class AccessToken < ApplicationRecord
  belongs_to :user
  belongs_to :verification_code

  validates :expires_at, :status, :token, presence: true

  ACTIVE = 'active'.freeze
  EXPIRED = 'expired'.freeze

  STATUS_TYPES = [
    ACTIVE,
    EXPIRED
  ].freeze

  scope :active, -> { where(active: ACTIVE) }
end
