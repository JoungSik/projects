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
end
