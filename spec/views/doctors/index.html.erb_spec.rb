require 'rails_helper'

RSpec.describe "doctors/index", type: :view do
  before(:each) do
    assign(:doctors, [
      Doctor.create!(
        name: "Name",
        address: "MyText",
        image_url: "Image Url",
        fees: "9.99",
        busy_slots: "Busy Slots"
      ),
      Doctor.create!(
        name: "Name",
        address: "MyText",
        image_url: "Image Url",
        fees: "9.99",
        busy_slots: "Busy Slots"
      )
    ])
  end

  it "renders a list of doctors" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Image Url".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("9.99".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Busy Slots".to_s), count: 2
  end
end
