class DashboardController < ApplicationController
  def index
    @tasks_by_status_count = Task.statuses.keys.map(&:to_sym).index_with { 0 }
                                 .merge(Task.where(assign_user: @current_user).group(:status).count.symbolize_keys)
    @tasks_by_status_count[:total] = @tasks_by_status_count.values.sum

    @tasks_by_due_status = Task.includes(:project).where(assign_user: @current_user, end_at: ..Date.today.end_of_week)
                               .where.not(status: [ :completed, :cancelled ])
                               .each_with_object({ due_today: [], due_this_week: [], overdue: [] }) do |task, hash|
      case task.end_at
      when ...Date.today.beginning_of_week then hash[:overdue] << task
      when Date.today then hash[:due_today] << task
      else hash[:due_this_week] << task
      end
    end

    tasks_count_by_weekday = Task.where(assign_user: @current_user, status: :completed, updated_at: Date.today.beginning_of_week..Date.today.end_of_week)
                                 .group_by { |task| task.updated_at.wday }
                                 .transform_values(&:count)
    @weekly_completed_tasks_count = [ 1, 2, 3, 4, 5, 6, 0 ].map { |day| tasks_count_by_weekday[day] || 0 }

    @workspaces = @current_user.workspaces.includes(:workspace_users)
  end
end
