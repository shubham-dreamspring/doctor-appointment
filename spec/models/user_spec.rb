require 'rails_helper'

RSpec.describe User, type: :model do
  context "attributes should be valid" do
    it "email can't be empty" do
      user = User.new({ name: 'Shubham Jain' })
      expect(user.invalid?).to be_truthy
    end
    it "name can't be empty" do
      user = User.new({ email:'12.34@fs.com' })
      expect(user.invalid?).to be_truthy
    end
    it "email should be valid" do
      user = User.new({ email:'12' })
      expect(user.invalid?).to be_truthy
    end
  end

end
