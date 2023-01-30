class Session < ApplicationRecord
  include UuidHandler

  validates :ip_address, presence: true

  belongs_to :user, optional: true
  has_many :purchase_carts, dependent: :destroy
  has_many :page_views, dependent: :destroy

  scope :more_than_one_month_old, -> { where('updated_at < ?', 1.month.ago) }
  scope :with_no_purchase_carts, -> { where.not(id: PurchaseCart.all.pluck(:session_id)) }
end
