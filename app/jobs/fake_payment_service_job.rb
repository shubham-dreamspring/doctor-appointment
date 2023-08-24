class FakePaymentServiceJob < ApplicationJob
  queue_as :default

  def perform(appointment, tracking_id)
    Turbo::StreamsChannel.broadcast_render_later_to(
      "Appointment - #{tracking_id}",
      partial: 'appointments/success',
      locals: { appointment: appointment }
    )
  end
end
