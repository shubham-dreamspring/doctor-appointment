require 'rails_helper'

RSpec.describe "doctors/index", type: :view do
  before(:each) do
    assign(:doctors, [
      Doctor.create!(
        name: "Name",
        address: "MyText",
        image_url: "image1.png",
        fees: "9.99"
      ),
      Doctor.create!(
        name: "Name",
        address: "MyText",
        image_url: "image1.png",
        fees: "9.99"
      )
    ])
  end

  it "renders a list of doctors" do
    render

    expect(rendered).to match /Name/
    cell_selector = '.doctor-card'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
  end
end
