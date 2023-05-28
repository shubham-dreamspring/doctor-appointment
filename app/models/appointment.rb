class Appointment < ApplicationRecord
  belongs_to :doctor
  belongs_to :user

  validates :start_timestamp,:end_timestamp, :user_id, :doctor_id, :amount, presence: true
  validates :amount, numericality: {greater_than_or_equal_to: 0.01}
end
