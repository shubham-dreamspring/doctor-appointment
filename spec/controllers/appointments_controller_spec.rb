require "rails_helper"
require_relative '../../app/controllers/concerns/user_session'

RSpec.describe AppointmentsController, type: :controller do
  include UserSession

  fixtures :doctors
  fixtures :users

  let(:valid_attributes) {
    [{
       doctor_id: 1,
       user_name: users(:one).name,
       user_email: users(:one).email,
       end_timestamp: Time.now,
       start_timestamp: Time.now.to_i,
       currency: 'INR',
       amount: 50
     },
     {
       doctor_id: 1,
       user_id: users(:one).id,
       end_timestamp: Time.now,
       start_timestamp: Time.now,
       currency: 'INR',
       amount: 50
     }
    ]
  }

  let(:invalid_attributes) {
    {
      doctor_id: 1,
      user_id: 2,
      start_timestamp: Time.now,
      currency: 'INR',
      amount: 50
    }
  }

  describe "GET index" do

    context 'user is logged in' do
      before do
        login(users(:one).id)
      end

      after do
        logout
      end

      it "renders the index template" do
        get :index
        expect(response).to render_template("index")
      end
    end

    context 'user is not logged in' do
      it "redirects to new user page" do
        get :index

        expect(response).to redirect_to(new_user_path)
      end
    end
  end

  describe "#new" do

    it "will render new template with doctor_id" do
      allow_any_instance_of(DoctorAvailableSlotService).to receive(:all_available_slots) { nil }
      request.params['doctor_id'] = doctors(:one).id

      get :new

      expect(response).to render_template("new")
    end
  end

  describe '#create' do
    before do
      allow(CurrencyConverterService).to receive(:currency_conversion_rate) { { 'INR' => 50 } }
    end

    context 'with valid attributes' do

      it "will increase the count of appointment" do
        expect {
          post :create, params: { appointment: valid_attributes[0] }, as: :turbo_stream
        }.to change(Appointment, :count).by(1)
      end

      it "will enqueue mailer" do
        expect(AppointmentMailer).to receive_message_chain(:with, :send_invoice, :deliver_later)

        post :create, params: { appointment: valid_attributes[0] }, as: :turbo_stream
      end

      it "will enqueue fake service job" do
        expect(FakePaymentServiceJob).to receive_message_chain(:set, :perform_later)

        post :create, params: { appointment: valid_attributes[0] }, as: :turbo_stream
      end
    end

    context "with invalid attributes" do
      it "should throw validation error" do
        post :create, params: { appointment: invalid_attributes }, as: :turbo_stream

        expect(response).to have_http_status :bad_request
      end
    end
  end

  describe '#show' do
    fixtures(:appointments)
    it 'it will render show template' do
      get :show, params: { id: appointments(:one).id }
    end
  end

  describe "#destroy" do
    it "will change appointment with -1" do
      appointment = Appointment.create! valid_attributes[1]
      expect {
        delete :destroy, params: { id: appointment.id }
      }.to change(Appointment, :count).by(-1)
    end

  end
end