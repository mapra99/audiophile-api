# frozen_string_literal: true

module Sessions
  class OldSessionsRemoverJob < ApplicationJob
    queue_as :default

    def perform
      Sessions::OldSessionsRemover.new.call
    end
  end
end
