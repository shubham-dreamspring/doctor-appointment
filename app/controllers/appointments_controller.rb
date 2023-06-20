require_relative 'concerns/render_pdf'

class AppointmentsController < ApplicationController
  before_action :set_appointment, only: %i[ show edit update destroy ]
  before_action :set_allowed_currencies, :set_currency_conversion_rate, only: %i[ new create ]
  include CurrencyConverterHelper
  # GET /appointments or /appointments.json
  def index
    @appointments = []
    redirect_to new_user_path unless session['user_id']
    @appointments = Appointment.where(user_id: session['user_id']) if session['user_id']
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
    @appointment = Appointment.new(:doctor_id => params[:doctor_id])
    doctor = Doctor.find(params[:doctor_id])
    @time_slots = {}
    get_available_time_slots doctor
    @doctor_fees = doctor.fees
  end

  # GET /appointments/1/edit
  def edit
  end

  # POST /appointments or /appointments.json
  def create
    users = User.where(email: user_params[:user_email])

    if users.empty?
      user = User.new({ name: user_params[:user_name], email: user_params[:user_email] })
      if user.save
        @user = user
      else
        flash[:error] = user.errors.full_messages
      end
    else
      @user = users[0]
    end
    session['user_id'] = @user.id
    params['appointment']['start_timestamp'] = Time.at(Integer(params['appointment']['start_timestamp'].to_s))
    params['appointment']['end_timestamp'] = params['appointment']['start_timestamp'] + 1.hour
    params['appointment']['user_id'] = @user.id
    doctor = Doctor.find(params['appointment']['doctor_id'])
    params['appointment']['amount'] = @currency_conversion_rate[params['appointment']['currency']] * doctor.fees
    @appointment = Appointment.new(appointment_params)

    respond_to do |format|
      if @appointment.save
        mailer = AppointmentMailer.with(appointment_id: @appointment.id).send_invoice.deliver_later(wait_until: 2.hour.from_now)
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(:new_appointment,
                                                    partial: 'success',
                                                    locals: { appointment: @appointment })
        end
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
    params.require(:appointment).permit(:doctor_id, :user_id, :end_timestamp, :start_timestamp, :currency, :amount)
  end

  def user_params
    params.require(:appointment).permit(:user_name, :user_email)
  end

  def general_day_time_slots(doctor)
    start_time = doctor.start_time.in_time_zone('Kolkata')
    end_time = doctor.end_time.in_time_zone('Kolkata')
    break_start_time = Time.parse('2000-01-01 ' + doctor.busy_slots[0].split[0] + " UTC")
    break_start_time = break_start_time.in_time_zone('Kolkata')
    break_end_time = break_start_time + doctor.busy_slots[0].split[1].to_f.hour
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

  def set_currency_conversion_rate
    cached_conversion_rates = Rails.cache.read('conversion_rates')

    if !cached_conversion_rates.nil? && cached_conversion_rates[:timestamp].today?
      @currency_conversion_rate = cached_conversion_rates[:conversion_rates]
      return
    end
    conversion_rates = {}
    @allowed_currencies.each do |cur|
      conversion_rates[cur] = currency_converter(base_amount: 1, target_currency: cur)["new_amount"]
    end
    Rails.cache.write('conversion_rates', { conversion_rates: conversion_rates, timestamp: Time.now }, expires_in: 1.days)
    @currency_conversion_rate = conversion_rates
  end

  def set_allowed_currencies
    @allowed_currencies = %w[EUR USD INR]
  end

  def get_available_time_slots(doctor)
    gen_time_slots = general_day_time_slots doctor
    sql_query_string = "SELECT start_timestamp FROM appointments WHERE start_timestamp >= current_timestamp and doctor_id = #{doctor.id} ORDER BY start_timestamp;"
    appointment_booked = Appointment.find_by_sql(sql_query_string)
    appointment_booked_array = []
    appointment_booked.each { |row| appointment_booked_array << row[:start_timestamp] }
    date = Date.today
    8.times do
      key = date
      time_slots_for_day = []
      gen_time_slots.each do |t|
        time_at_given_slot = Time.new(date.year, date.month, date.day, t.hour, t.min)
        index_in_booked_appointment = appointment_booked_array.index time_at_given_slot
        if index_in_booked_appointment
          appointment_booked_array.delete_at index_in_booked_appointment
          next
        end
        time_slots_for_day << time_at_given_slot if (time_at_given_slot > Time.now)
      end
      @time_slots[key] = time_slots_for_day
      date = date + 1.day
    end
  end
end
