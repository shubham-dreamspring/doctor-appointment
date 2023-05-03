class Doctor < ApplicationRecord
  has_many :appointments

  before_destroy :referenced_by_no_appointment

  private

  def referenced_by_no_appointment
    unless appointments.empty?
      errors.add(:base, 'Appointments is present')
      throw :abort
    end
  end

end
