class PaymentEvent < ApplicationRecord
  belongs_to :payment

  validates :event_name, presence: true
  validates :raw_data, presence: true
end
