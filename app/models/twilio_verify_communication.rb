class TwilioVerifyCommunication < ApplicationRecord
  belongs_to :communication
  belongs_to :target, polymorphic: true, optional: true

  validates :recipient, :verification_sid, :channel, :service_sid, presence: true
end
