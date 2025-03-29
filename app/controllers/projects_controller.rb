class ProjectsController < ApplicationController
  before_action :set_workspace
  before_action :set_project, only: %i[ show edit update destroy ]

  # GET /projects/1
  def show
    @tasks = @project.tasks.includes(:assign_user)
                     .where(tasks: { updated_at: DateTime.now - 2.weeks... })
                     .order(tasks: { priority: :asc, end_at: :asc })
                     .group_by(&:status)

    @archived_tasks = @project.tasks.includes(:assign_user)
                              .where(tasks: { status: [ :completed, :cancelled ], updated_at: ...DateTime.now - 2.weeks })
                              .order(tasks: { updated_at: :desc })
                              .group_by(&:status)
                              .transform_keys(&:to_sym)
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  def create
    @project = Project.new(project_params)

    if @project.save
      redirect_to workspace_path(@workspace), notice: t(".messages.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /projects/1
  def update
    if @project.update(project_params)
      redirect_to workspace_project_path(@workspace, @project), notice: t(".messages.updated"), status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /projects/1
  def destroy
    @project.destroy!
    redirect_to workspace_path(@workspace), notice: t(".messages.destroyed"), status: :see_other
  end

  private

  # Only allow a list of trusted parameters through.
  def project_params
    params.require(:project).permit(:title, :description, :owner_id, :creator_id, :workspace_id)
  end
end
