# frozen_string_literal: true

class Communication < ApplicationRecord
  has_many :email_communications, dependent: :destroy

  validates :topic, presence: true

  VERIFICATION_CODE_TOPIC = 'verification_code'
  SUCCESS_PAYMENT_TOPIC = 'success_payment'
  FAILED_PAYMENT_TOPIC = 'failed_payment'

  TOPICS = [
    VERIFICATION_CODE_TOPIC,
    SUCCESS_PAYMENT_TOPIC,
    FAILED_PAYMENT_TOPIC
  ].freeze
end
