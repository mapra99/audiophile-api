class PurchaseCart < ApplicationRecord
  include UuidHandler

  STARTED = 'started'.freeze
  PAID = 'paid'.freeze
  CANCELED = 'canceled'.freeze

  STATUS_TYPES = [
    STARTED,
    PAID,
    CANCELED
  ].freeze

  validates :total_price, presence: true
  validates :status, presence: true, inclusion: { in: STATUS_TYPES }
  validates_with Validators::PurchaseCartStatusValidator

  has_many :purchase_cart_items, dependent: :destroy
  has_many :purchase_cart_extra_fees, dependent: :destroy
  belongs_to :session

  scope :started, -> { where(status: STARTED) }

  def update_total_price!
    items_price = purchase_cart_items.map(&:total_price).sum
    extra_fees = purchase_cart_extra_fees.pluck(:price).sum

    update!(total_price: items_price + extra_fees)
  end
end
