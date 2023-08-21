require 'rails_helper'

RSpec.describe "/doctors", type: :request do

  let(:valid_attributes) {
    {
      name: "Dr. Hynes",
      address: "Stanford University",
      image_url: "doctor1_image.png",
      fees: 0.56789e5,
      busy_slots: ['07:30 1'],
      start_time: '06:30',
      end_time: '10:30'
    }
  }

  let(:invalid_attributes) {
    {
      address: "Celebrium, Human Brain",
      image_url: "doctor2_image.png",
      start_time: '06:30',
      end_time: '10:30'
    }
  }

  describe "GET /index" do
    it "renders a successful response" do
      Doctor.create! valid_attributes
      get doctors_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      doctor = Doctor.create! valid_attributes
      get doctor_url(doctor)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_doctor_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      doctor = Doctor.create! valid_attributes
      get edit_doctor_url(doctor)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Doctor" do
        expect {
          post doctors_url, params: { doctor: valid_attributes }
        }.to change(Doctor, :count).by(1)
      end

      it "redirects to the created doctor" do
        post doctors_url, params: { doctor: valid_attributes }
        expect(response).to redirect_to(doctor_url(Doctor.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Doctor" do
        expect {
          post doctors_url, params: { doctor: invalid_attributes }
        }.to change(Doctor, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post doctors_url, params: { doctor: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

    end
  end
end
