class AppointmentMailer < ApplicationMailer
  default from: "rpratap94110@gmail.com"

  def send_invoice
    @appointment = Appointment.find_by(id: params[:appointment_id])
    return unless @appointment
    mail to: @appointment.user.email, subject: 'Your Invoice for Doc appointment'
  end
end
