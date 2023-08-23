class Doctor < ApplicationRecord
  has_many :appointments

  before_destroy :referenced_by_no_appointment

  validates :name, :fees, :image_url, presence: true
  validates :fees, numericality: { greater_than_or_equal_to: 0.01 }

  def is_sunday_off?
    true
  end

  def next_available_slot
    DoctorAvailableSlotService.new(self).next_available_slot
  end

  private

  def referenced_by_no_appointment
    unless appointments.empty?
      errors.add(:base, I18n.t('appointments_is_present'))
      throw :abort
    end
  end

end
