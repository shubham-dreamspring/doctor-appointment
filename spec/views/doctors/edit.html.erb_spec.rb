require 'rails_helper'

RSpec.describe "doctors/edit", type: :view do
  let(:doctor) {
    Doctor.create!(
      name: "MyString",
      address: "MyText",
      image_url: "MyString",
      fees: "9.99"
    )
  }

  before(:each) do
    assign(:doctor, doctor)
  end

  it "renders the edit doctor form" do
    render

    assert_select "form[action=?][method=?]", doctor_path(doctor), "post" do

      assert_select "input[name=?]", "doctor[name]"

      assert_select "textarea[name=?]", "doctor[address]"

      assert_select "input[name=?]", "doctor[image_url]"

      assert_select "input[name=?]", "doctor[fees]"

    end
  end
end
