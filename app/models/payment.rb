class Payment < ApplicationRecord
  include UuidHandler

  belongs_to :user
  belongs_to :purchase_cart
  has_many :payment_events, dependent: :destroy

  validates :status, :amount, :provider_id, presence: true

  STARTED = 'started'.freeze
  PENDING = 'pending'.freeze
  COMPLETED = 'completed'.freeze
  CANCELED = 'canceled'.freeze

  STATUS_TYPES = [
    STARTED,
    PENDING,
    COMPLETED,
    CANCELED
  ].freeze
end
