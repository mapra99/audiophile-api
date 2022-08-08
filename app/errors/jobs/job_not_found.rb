module Jobs
  class JobNotFound < StandardError
    def initialize(jid)
      message = "Job with ID #{jid} not found"

      super(message)
    end
  end
end
