require 'rails_helper'

RSpec.describe "appointments/index", type: :view do
  before(:each) do
    dummy_doctor = Doctor.create({ name: "Dr. Octopus",
                                   address: "Water Colony, Red Sea",
                                   image_url: "doctor3_image.png",
                                   fees: 0.345e3 })
    dummy_user = User.create({
                               name: 'Shubham',
                               email: 'abc@email.com'
                             })
    assign(:appointments, [
      Appointment.create!(
        doctor_id: dummy_doctor.id,
        user_id: dummy_user.id,
        start_timestamp: Date.new,
        end_timestamp: Date.new + 1.day,
        amount: 23
      ),
      Appointment.create!(
        doctor_id: dummy_doctor.id,
        user_id: dummy_user.id,
        start_timestamp: Date.new,
        end_timestamp: Date.new + 1.day,
        amount: 23
      )
    ])
  end

  it "renders a list of appointments" do
    render
    cell_selector = '.appointment-card'
    assert_select cell_selector, text: /Dr. Octopus/, count: 2
    assert_select cell_selector, text: /Dr. Octopus/, count: 2
  end
end
