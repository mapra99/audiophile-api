# frozen_string_literal: true

class Communication < ApplicationRecord
  has_many :email_communications, dependent: :destroy

  validates :topic, presence: true

  VERIFICATION_CODE_TOPIC = 'verification_code'
  TOPICS = [
    VERIFICATION_CODE_TOPIC
  ].freeze
end
