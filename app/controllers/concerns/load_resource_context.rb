module LoadResourceContext
  extend ActiveSupport::Concern

  include RenderErrors

  private

  def set_workspace
    @workspace = @current_user.workspaces.find_by(id: workspace_id_from_params)
    render_not_found(t("shared.message.error.not_found_workspace")) unless @workspace
  end

  def set_project
    @project = @workspace.projects.find_by(id: project_id_from_params)
    render_not_found(t("shared.message.error.not_found_project")) unless @project
  end

  def set_task
    @task = @project.tasks.find_by(id: task_id_from_params)
    render_not_found(t("shared.message.error.not_found_task")) unless @task
  end

  def workspace_id_from_params
    return params[:workspace_id] if params[:workspace_id].present?
    params[:id]
  end

  def project_id_from_params
    return params[:project_id] if params[:project_id].present?
    params[:id]
  end

  def task_id_from_params
    params[:id]
  end
end
