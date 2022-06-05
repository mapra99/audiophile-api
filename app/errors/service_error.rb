class ServiceError < StandardError
  attr_reader :failure

  def initialize(failure)
    @failure = failure
    super
  end
end
