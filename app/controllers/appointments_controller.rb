class AppointmentsController < ApplicationController
  before_action :set_appointment, only: %i[ show edit update destroy ]

  # GET /appointments or /appointments.json
  def index
    @appointments = Appointment.all
  end

  # GET /appointments/1 or /appointments/1.json
  def show
  end

  # GET /appointments/new
  def new
    @appointment = Appointment.new(:doctor_id => params[:doctor_id])
    doctor = Doctor.find(params[:doctor_id])
    @time_slots = {}
    gen_time_slots = general_day_time_slots doctor
    date = Date.today
    9.times do
      key = date
      time_slots_for_day = []
      gen_time_slots.each { |t| time_slots_for_day << Time.new(date.year, date.month, date.day, t.hour, t.min) }
      @time_slots[key] = time_slots_for_day
      date = date + 1.day
    end
  end

  # GET /appointments/1/edit
  def edit
  end

  # POST /appointments or /appointments.json
  def create
    @appointment = Appointment.new(appointment_params)

    respond_to do |format|
      if @appointment.save
        format.html { redirect_to appointment_url(@appointment), notice: "Appointment was successfully created." }
        format.json { render :show, status: :created, location: @appointment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /appointments/1 or /appointments/1.json
  def update
    respond_to do |format|
      if @appointment.update(appointment_params)
        format.html { redirect_to appointment_url(@appointment), notice: "Appointment was successfully updated." }
        format.json { render :show, status: :ok, location: @appointment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /appointments/1 or /appointments/1.json
  def destroy
    @appointment.destroy

    respond_to do |format|
      format.html { redirect_to appointments_url, notice: "Appointment was successfully destroyed." }
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
    params.require(:appointment).permit(:doctor_id, :user_id, :start_timestamp, :end_timestamp, :currency, :amount)
  end

  def general_day_time_slots(doctor)
    start_time = doctor.start_time
    end_time = doctor.end_time
    break_start_time = Time.parse('2000-01-01 ' + doctor.busy_slots[0].split[0] + ' ' + doctor.busy_slots[0].split[1] + " UTC +00:00")
    break_end_time = break_start_time + doctor.busy_slots[0].split[2].to_f.hour
    general_time_slots = []

    while break_start_time - start_time >= 3600 do
      general_time_slots.push start_time
      start_time = start_time + 1.hour
    end
    while end_time - break_end_time >= 3600 do
      general_time_slots.push break_end_time
      break_end_time = break_end_time + 1.hour
    end
    general_time_slots
  end
end
