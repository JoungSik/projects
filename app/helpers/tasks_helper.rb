module TasksHelper
  # class="bg-purple-100 text-purple-700"
  # class="bg-blue-100 text-blue-700"
  # class="bg-red-100 text-red-700""
  def task_type_color(task)
    case task.type_before_type_cast
    when 0 then "purple"
    when 1 then "blue"
    when 2 then "red"
    else "blue"
    end
  end

  # class="bg-red-100 text-red-700"
  # class="bg-orange-100 text-orange-700"
  # class="bg-gray-100 text-gray-700"
  def task_priority_color(task)
    case task.priority_before_type_cast
    when 0, 1 then "red"
    when 2, 3 then "orange"
    when 4 then "gray"
    else "gray"
    end
  end

  # class="border-gray-200 bg-gray-50 bg-gray-100 text-gray-500"
  # class="border-blue-200 bg-blue-50 bg-blue-100 text-blue-500"
  # class="border-red-200 bg-red-50 bg-red-100 text-red-500"
  # class="border-green-200 bg-green-50 bg-green-100 text-green-500"
  def task_status_color(task)
    case task.status_before_type_cast
    when 0 then "gray"
    when 1 then "blue"
    when 2, 4 then "red"
    when 3 then "green"
    else "gray"
    end
  end

  def task_status_title_icon(status)
    case status
    when 0 then "clock"
    when 1 then "loader"
    when 2 then "alert-circle"
    when 3 then "check-circle"
    when 4 then "x-circle"
    else "archive-restore"
    end
  end

  # class="text-gray-500"
  # class="text-blue-500"
  # class="text-green-500"
  # class="text-yellow-500"
  # class="text-red-500"
  def task_status_title_color(status)
    case status
    when 0 then "gray"
    when 1 then "blue"
    when 2 then "yellow"
    when 3 then "green"
    when 4 then "red"
    else "gray"
    end
  end

  # 빈 상태 카드 스타일 반환 - 성능 최적화 버전
  def empty_state_card_classes(status)
    case status
    when 0 # not_started - gray
      {
        container: "relative bg-gray-50 border-2 border-dashed border-gray-200 rounded-lg p-4 transition-all duration-200 hover:border-gray-300 drag-optimized sortable-transition",
        badge: "px-2 py-1 text-xs bg-gray-100 text-gray-600 rounded-full opacity-60",
        title: "font-medium text-gray-500 mb-3 flex items-center empty-state-title",
        avatar_bg: "w-6 h-6 rounded-full bg-gray-100 flex items-center justify-center",
        avatar_icon: "w-3 h-3 text-gray-400",
        text: "text-xs text-gray-500",
        icon: "w-4 h-4 mr-1 text-gray-400",
        description: "text-gray-400 text-xs"
      }
    when 1 # in_progress - blue
      {
        container: "relative bg-blue-50 border-2 border-dashed border-blue-200 rounded-lg p-4 transition-all duration-200 hover:border-blue-300 drag-optimized sortable-transition",
        badge: "px-2 py-1 text-xs bg-blue-100 text-blue-600 rounded-full opacity-60",
        title: "font-medium text-blue-500 mb-3 flex items-center empty-state-title",
        avatar_bg: "w-6 h-6 rounded-full bg-blue-100 flex items-center justify-center",
        avatar_icon: "w-3 h-3 text-blue-400",
        text: "text-xs text-blue-500",
        icon: "w-4 h-4 mr-1 text-blue-400",
        description: "text-blue-400 text-xs"
      }
    when 2 # overdue - yellow
      {
        container: "relative bg-yellow-50 border-2 border-dashed border-yellow-200 rounded-lg p-4 transition-all duration-200 hover:border-yellow-300 drag-optimized sortable-transition",
        badge: "px-2 py-1 text-xs bg-yellow-100 text-yellow-600 rounded-full opacity-60",
        title: "font-medium text-yellow-500 mb-3 flex items-center empty-state-title",
        avatar_bg: "w-6 h-6 rounded-full bg-yellow-100 flex items-center justify-center",
        avatar_icon: "w-3 h-3 text-yellow-400",
        text: "text-xs text-yellow-500",
        icon: "w-4 h-4 mr-1 text-yellow-400",
        description: "text-yellow-400 text-xs"
      }
    when 3 # completed - green
      {
        container: "relative bg-green-50 border-2 border-dashed border-green-200 rounded-lg p-4 transition-all duration-200 hover:border-green-300 drag-optimized sortable-transition",
        badge: "px-2 py-1 text-xs bg-green-100 text-green-600 rounded-full opacity-60",
        title: "font-medium text-green-500 mb-3 flex items-center empty-state-title",
        avatar_bg: "w-6 h-6 rounded-full bg-green-100 flex items-center justify-center",
        avatar_icon: "w-3 h-3 text-green-400",
        text: "text-xs text-green-500",
        icon: "w-4 h-4 mr-1 text-green-400",
        description: "text-green-400 text-xs"
      }
    when 4 # cancelled - red
      {
        container: "relative bg-red-50 border-2 border-dashed border-red-200 rounded-lg p-4 transition-all duration-200 hover:border-red-300 drag-optimized sortable-transition",
        badge: "px-2 py-1 text-xs bg-red-100 text-red-600 rounded-full opacity-60",
        title: "font-medium text-red-500 mb-3 flex items-center empty-state-title",
        avatar_bg: "w-6 h-6 rounded-full bg-red-100 flex items-center justify-center",
        avatar_icon: "w-3 h-3 text-red-400",
        text: "text-xs text-red-500",
        icon: "w-4 h-4 mr-1 text-red-400",
        description: "text-red-400 text-xs"
      }
    else # archived - gray
      {
        container: "relative bg-gray-50 border-2 border-dashed border-gray-200 rounded-lg p-4 transition-all duration-200 hover:border-gray-300 drag-optimized sortable-transition",
        badge: "px-2 py-1 text-xs bg-gray-100 text-gray-600 rounded-full opacity-60",
        title: "font-medium text-gray-500 mb-3 flex items-center empty-state-title",
        avatar_bg: "w-6 h-6 rounded-full bg-gray-100 flex items-center justify-center",
        avatar_icon: "w-3 h-3 text-gray-400",
        text: "text-xs text-gray-500",
        icon: "w-4 h-4 mr-1 text-gray-400",
        description: "text-gray-400 text-xs"
      }
    end
  end
end
