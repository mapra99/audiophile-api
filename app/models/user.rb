class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: 'invalid format' }
  validates :name, presence: true
  validates :phone, presence: true

  has_many :email_communications, as: :target, dependent: :destroy
  has_many :verification_codes, dependent: :destroy
  has_many :access_tokens, dependent: :destroy
  has_many :user_locations, dependent: :destroy
  has_many :locations, through: :user_locations
  has_many :sessions, dependent: :destroy
  has_many :purchase_carts, through: :sessions
  has_many :payments, dependent: :destroy

  def latest_started_verification_code
    verification_codes.started.last
  end
end
