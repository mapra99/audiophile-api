# frozen_string_literal: true

class EmailCommunication < ApplicationRecord
  belongs_to :communication
  belongs_to :target, polymorphic: true, optional: true

  validates :sender, :recipient, :template_id, :template_data, presence: true

  AUTH_SENDER_EMAIL = 'auth@audiophiley.com'
  SENDERS = [
    AUTH_SENDER_EMAIL
  ].freeze
end
