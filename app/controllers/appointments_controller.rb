require_relative '../services/currency_converter_service'

class AppointmentsController < ApplicationController
  before_action :set_appointment, only: %i[ show edit update destroy ]
  before_action :set_allowed_currencies, only: %i[ new create ]
  include PdfGeneratorHelper
  include UserSession
  # GET /appointments or /appointments.json
  def index
    unless login?
      redirect_to new_user_path
      return
    end
    @appointments = logged_in_user.appointments
  end

  # GET /appointments/1 or /appointments/1.json
  def show

    respond_to do |format|
      format.html
      format.json
      format.pdf do
        invoice = render_to_string partial: 'appointment', locals: { appointment: @appointment }
        render_pdf invoice, filename: "Invoice #{@appointment.id}"
      end
      format.csv
      format.txt
    end
  end

  # GET /appointments/new
  def new
    @appointment = Appointment.new(doctor_id: params[:doctor_id])
    @time_slots = DoctorAvailableSlotService.new(@appointment.doctor).all_available_slots
  end

  # POST /appointments or /appointments.json
  def create
    @user = User.find_or_create_by(email: user_params[:user_email], name: user_params[:user_name])
    unless @user.valid?
      flash[:error] = 'Invalid Email'
      redirect_to new_appointment_path(params: { doctor_id: params['appointment']['doctor_id'] }), status: :bad_request
      return
    end
    login @user.id

    @appointment = Appointment.new(appointment_params)

    respond_to do |format|
      if @appointment.save
        AppointmentMailer.with(appointment_id: @appointment.id).send_invoice.deliver_later(wait_until: 2.hour.from_now)
        format.turbo_stream do
          FakePaymentServiceJob.set(wait:1.second).perform_later(@appointment)
        end

      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /appointments/1 or /appointments/1.json
  def destroy
    @appointment.destroy

    respond_to do |format|
      format.html { redirect_to appointments_url, notice: "Appointment was successfully cancelled." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_appointment
    @appointment = Appointment.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def appointment_params
    params['appointment']['start_timestamp'] = Time.at(Integer(params['appointment']['start_timestamp'].to_s)).in_time_zone('UTC')
    params['appointment']['end_timestamp'] = params['appointment']['start_timestamp'] + 1.hour
    params['appointment']['user_id'] = @user.id
    doctor = Doctor.find(params['appointment']['doctor_id'])
    params['appointment']['amount'] = helpers.currency_converter params['appointment']['currency'], doctor.fees
    params.require(:appointment).permit(:doctor_id, :user_id, :end_timestamp, :start_timestamp, :currency, :amount)
  end

  def user_params
    params.require(:appointment).permit(:user_name, :user_email)
  end

  def set_allowed_currencies
    @allowed_currencies = %w[EUR USD INR]
  end

end
