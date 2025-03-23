class TasksController < ApplicationController
  before_action :set_workspace
  before_action :set_project
  before_action :set_task, only: %i[ show edit update destroy ]

  # GET /tasks/1
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to workspace_project_path(@workspace, @project), notice: t(".messages.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tasks/1
  def update
    if @task.update(task_params)
      redirect_to workspace_project_path(@workspace, @project), notice: t(".messages.updated"), status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /tasks/1
  def destroy
    @task.destroy!
    redirect_to workspace_project_path(@workspace, @project), notice: t(".messages.destroyed"), status: :see_other
  end

  private

  # Only allow a list of trusted parameters through.
  def task_params
    params.require(:task).permit(:title, :description, :type, :priority, :status, :start_at, :end_at, :project_id, :assign_user_id, :creator_id)
  end
end
