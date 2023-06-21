require 'rails_helper'

RSpec.describe "doctors/show", type: :view do
  before(:each) do
    assign(:doctor, Doctor.create!(
      name: "Name",
      address: "MyText",
      image_url: "image1.png",
      fees: "9.99"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match /Name/
    cell_selector = '.doctor-card'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 1
  end
end
