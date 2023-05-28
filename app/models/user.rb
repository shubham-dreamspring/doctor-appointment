class User < ApplicationRecord
  include EmailValidator

  has_many :appointments, dependent: :destroy

  validates :email, presence: true, uniqueness: { case_sensitive: false },
            format: { with: VALID_EMAIL_REGEX, multiline: true }
  validates :name, presence: true
end
