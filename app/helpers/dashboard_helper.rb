module DashboardHelper

  def combined_status_percentage(target_statuses, task_counts)
    return 0.0 if task_counts[:total].zero?

    combined_count = target_statuses.sum { |status| task_counts[status] || 0 }
    (combined_count.to_f / task_counts[:total] * 100).round(1)
  end

  # class="h-16 h-24 h-32 h-40 h-48 h-56"
  def weekly_progress_height(index_rank)
    "h-#{(index_rank + 1) * 8}"
  end

  # class="bg-indigo-100 bg-indigo-200 bg-indigo-300 bg-indigo-400 bg-indigo-500 bg-indigo-600 bg-indigo-700"
  def weekly_progress_color(wday)
    "bg-indigo-#{(wday + 1) * 100}"
  end
end
