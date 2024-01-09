# frozen_string_literal: true

module Communications
  class TwilioVerificationSenderJob < ApplicationJob
    queue_as :default

    def perform(target:, channel:)
      Communications::TwilioVerificationSender.new(
        target: target,
        channel: channel
      ).call
    end
  end
end
