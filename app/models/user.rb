class User < ApplicationRecord
  include EmailValidator

  has_many :appointments, dependent: :destroy

  validates :email, presence: true, uniqueness: { case_sensitive: true }, format: { with: VALID_EMAIL_REGEX }
  validates :name, presence: true
end
