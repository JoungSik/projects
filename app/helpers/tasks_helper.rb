module TasksHelper
  def task_type_color(task)
    case task.type_before_type_cast
    when 0 then "purple"
    when 1 then "blue"
    when 2 then "red"
    else "blue"
    end
  end

  def task_priority_color(task)
    case task.priority_before_type_cast
    when 0, 1 then "red"
    when 2, 3 then "orange"
    when 4 then "gray"
    else "gray"
    end
  end

  def task_status_color(task)
    case task.status_before_type_cast
    when 0, 1 then "black"
    when 2 then "red"
    when 3, 4 then "green"
    else "black"
    end
  end

  def task_status_title_icon(status)
    case status
    when 0 then "clock"
    when 1 then "loader"
    when 2 then "check-circle"
    when 3 then "x-circle"
    when 4 then "alert-circle"
    else "loader"
    end
  end

  def task_status_title_color(status)
    case status
    when 0 then "gray"
    when 1 then "blue"
    when 2 then "green"
    when 3 then "yellow"
    when 4 then "red"
    else "gray"
    end
  end
end
