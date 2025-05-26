class ArchiveCompletedTasksJob < ApplicationJob
  queue_as :default

  def perform
    update_count = Task.completed.where(updated_at: ...1.month.ago).update_all(status: :archived)
  end
end
