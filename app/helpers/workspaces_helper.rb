module WorkspacesHelper
  # class="bg-indigo-50 text-indigo-700"
  # class="bg-gray-50 text-gray-700"
  def workspace_role_color(workspace_user)
    case workspace_user.role_before_type_cast
    when 0 then "indigo"
    when 1 then "gray"
    else "gray"
    end
  end
end
