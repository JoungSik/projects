module WorkspacesHelper
  def workspace_role_color(workspace_user)
    case workspace_user.role_before_type_cast
    when 0 then "indigo"
    when 1 then "gray"
    else "gray"
    end
  end
end
