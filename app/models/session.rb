class Session < ApplicationRecord
  include UuidHandler

  validates :ip_address, presence: true

  belongs_to :user, optional: true
  has_many :purchase_carts, dependent: :destroy
end
