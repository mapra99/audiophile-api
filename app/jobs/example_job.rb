class ExampleJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.info 'Running ExampleJob'
  end
end
