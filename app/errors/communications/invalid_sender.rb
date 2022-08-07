module Communications
  class InvalidSender < StandardError
    attr_reader :sender

    def initialize(sender)
      @sender = sender
      message = "Sender #{sender} is not valid. Must be one of #{EmailCommunication::SENDERS}"

      super(message)
    end
  end
end
