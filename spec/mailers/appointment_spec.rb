require "rails_helper"

RSpec.describe AppointmentMailer, type: :mailer do
  fixtures(:appointments)
  describe "send_invoice" do
    let(:mail) { AppointmentMailer.with(appointment_id: appointments(:two).id).send_invoice }

    it "renders the headers" do
      expect(mail.subject).to eq('Your Invoice for Doc appointment')
      expect(mail.to).to eql [appointments(:two).user.email]
      expect(mail.from).to eq(["rpratap94110@gmail.com"])
    end
  end

end
