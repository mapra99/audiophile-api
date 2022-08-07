module Communications
  class InvalidTopic < StandardError
    attr_reader :topic

    def initialize(topic)
      @topic = topic
      message = "Topic #{topic} is not valid. Must be one of #{Communication::TOPICS}"

      super(message)
    end
  end
end
