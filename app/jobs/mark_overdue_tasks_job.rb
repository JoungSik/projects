class MarkOverdueTasksJob < ApplicationJob
  queue_as :scheduled

  def perform
    today = Time.zone.today
    Task.where(end_at: ...today).where.not(status: :overdue).update_all(status: :overdue)
  end
end
