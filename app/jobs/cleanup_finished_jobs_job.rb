class CleanupFinishedJobsJob < ApplicationJob
  queue_as :system

  def perform
    SolidQueue::Job.finished.where(finished_at: ...7.days.ago).delete_all
  end
end
