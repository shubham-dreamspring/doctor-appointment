# Preview all emails at http://localhost:3000/rails/mailers/appointment
class AppointmentPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/appointment/send_invoice
  def send_invoice
    appointment = Appointment.new(id:2,user_id: 10, doctor_id: 9, start_timestamp: Time.current, end_timestamp: Time.current + 1.hour, currency: 'USD', amount: 34.344)
    AppointmentMailer.with(appointment: appointment).send_invoice
  end

end
