module ApplicationHelper
  def smart_back_link(index_path = nil)
    referer = request.referer.to_s

    if controller_name == "tasks" && action_name == "show" && referer.include?("/edit")
      index_path
    else
      :back
    end
  end

  def options_for_enum(model_class, enum)
    enum_hash = model_class.send(enum.to_s.pluralize)

    enum_hash.map do |key, _|
      [ t("activerecord.attributes.#{model_class.to_s.downcase}.#{enum}.#{key}"), key ]
    end
  end

  # class="text-gray-700 text-indigo-700 bg-indigo-50"
  def sidebar_color(workspace_id, current_workspace_id = nil)
    return "text-indigo-700 bg-indigo-50" if workspace_id == current_workspace_id

    "text-gray-700"
  end
end
