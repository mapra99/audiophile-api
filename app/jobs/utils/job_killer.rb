module Utils
  module JobKiller
    def kill!(sidekiq_job_id)
      scheduled_jobs = Sidekiq::ScheduledSet.new
      job = scheduled_jobs.scan(name).find do |j|
        j.jid == sidekiq_job_id
      end
      raise Jobs::JobNotFound, sidekiq_job_id if job.blank?

      job.delete
    end
  end
end
