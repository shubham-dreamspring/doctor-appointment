require 'rails_helper'

RSpec.describe "doctors/show", type: :view do
  before(:each) do
    assign(:doctor, Doctor.create!(
      name: "Name",
      address: "MyText",
      image_url: "Image Url",
      fees: "9.99",
      busy_slots: "Busy Slots"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Image Url/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/Busy Slots/)
  end
end
