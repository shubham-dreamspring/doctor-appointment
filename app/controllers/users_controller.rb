class UsersController < ApplicationController
  include UserSession

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/new
  def new
    @user = User.new
    @redirect_back = params['redirect_back']
  end

  # POST /users or /users.json
  def create
    params['user']['email'] = params['user']['email'].strip
    exist_user = User.find_by email: params['user']['email']
    if exist_user
      login exist_user.id
      authorise_for_appointment_page exist_user
      return
    elsif params['user']['redirect_back'] && params['user']['redirect_back'].match?(/appointments\/\d+$/)
      redirect_to request.referrer, notice: 'You are not authorised', status: :unauthorized
      return
    end

    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        login @user.id
        format.html { redirect_to appointments_path, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:name, :email, :role)
  end

  def authorise_for_appointment_page(exist_user)
    if params['user']['redirect_back'].match?(/appointments$/)
      redirect_to params['user']['redirect_back']
    elsif params['user']['redirect_back'].match?(/appointments\/\d+$/)
      appointment_id = params['user']['redirect_back'].match(/\d+$/)
      if exist_user.appointments.find_by_id(Integer(appointment_id.to_s))
        redirect_to params['user']['redirect_back']

      else
        redirect_to request.referrer, notice: 'You are not authorised', status: :unauthorized
      end
    end
  end

end
