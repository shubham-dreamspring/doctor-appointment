class AppointmentMailer < ApplicationMailer
  default from: ENV['EMAIL_USER_NAME']

  def send_invoice
    @appointment = Appointment.find_by(id: params[:appointment_id])
    return unless @appointment
    mail to: @appointment.user.email, subject: 'Your Invoice for Doc appointment'
  end
end
