class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :phone, presence: true

  has_many :email_communications, as: :target, dependent: :destroy
end
