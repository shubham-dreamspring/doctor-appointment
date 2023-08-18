class FakePaymentServiceJob < ApplicationJob
  queue_as :default

  def perform(appointment)
    Turbo::StreamsChannel.broadcast_render_later_to(
      :appointment_created,
      partial: 'appointments/success',
      locals: { appointment: appointment}
    )
  end
end
