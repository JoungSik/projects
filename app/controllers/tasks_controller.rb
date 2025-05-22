class TasksController < ApplicationController
  before_action :set_workspace
  before_action :set_project
  before_action :set_task, only: %i[ show edit update destroy ]

  # GET /tasks/1
  def show
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("modal",
                                                 partial: "shared/modal",
                                                 locals: {
                                                   title: @task.title,
                                                   modal_body_partial: "tasks/show",
                                                   modal_body_locals: { task: @task }
                                                 })
      end
    end
  end

  # GET /tasks/new
  def new
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("modal",
                                                 partial: "shared/modal",
                                                 locals: {
                                                   title: "작업 생성",
                                                   modal_body_partial: "tasks/form",
                                                   modal_body_locals: { task: Task.new }
                                                 })
      end
    end
  end

  # GET /tasks/1/edit
  def edit
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("modal",
                                                 partial: "shared/modal",
                                                 locals: {
                                                   title: "작업 수정",
                                                   modal_body_partial: "tasks/form",
                                                   modal_body_locals: { task: @task }
                                                 })
      end
    end
  end

  # POST /tasks
  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to workspace_project_path(@workspace, @project), notice: t(".messages.created")
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("modal",
                                                   partial: "shared/modal",
                                                   locals: {
                                                     title: "작업 생성",
                                                     modal_body_partial: "tasks/form",
                                                     modal_body_locals: { task: @task }
                                                   }),
                 status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /tasks/1
  def update
    if @task.update(task_params)
      redirect_to workspace_project_path(@workspace, @project), notice: t(".messages.updated"), status: :see_other
    else
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("modal",
                                                   partial: "shared/modal",
                                                   locals: {
                                                     title: "작업 수정",
                                                     modal_body_partial: "tasks/form",
                                                     modal_body_locals: { task: @task }
                                                   }),
                 status: :unprocessable_entity
        end
      end
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
