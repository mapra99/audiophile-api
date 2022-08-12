# frozen_string_literal: true

module Communications
  class EmailSenderJob < ApplicationJob
    queue_as :default

    def perform(topic:, sender:, recipient:, template_id:, template_data:, target: nil)
      Communications::EmailSender.new(
        topic: topic,
        sender: sender,
        recipient: recipient,
        template_id: template_id,
        template_data: template_data,
        target: target
      ).call
    end
  end
end
