# frozen_string_literal: true

module Communications
  class EmailSenderJob < ApplicationJob
    queue_as :default

    def perform(topic:, sender:, recipient:, subject:, template_id:, template_data:, target: nil)
      Communications::EmailSender.new(
        topic: topic,
        sender: sender,
        recipient: recipient,
        subject: subject,
        template_id: template_id,
        template_data: template_data,
        target: target
      ).call
    end
  end
end
