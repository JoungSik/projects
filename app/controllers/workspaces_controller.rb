class WorkspacesController < ApplicationController
  before_action :set_workspace, only: %i[ show edit update destroy ]

  # GET /workspaces
  def index
  end

  # GET /workspaces/1
  def show
  end

  # GET /workspaces/new
  def new
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("modal",
                                                 partial: "shared/modal",
                                                 locals: {
                                                   title: "새 작업공간",
                                                   modal_body_partial: "workspaces/form",
                                                   modal_body_locals: { workspace: Workspace.new }
                                                 })
      end
    end
  end

  # GET /workspaces/1/edit
  def edit
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("modal",
                                                 partial: "shared/modal",
                                                 locals: {
                                                   title: "작업공간 수정",
                                                   modal_body_partial: "workspaces/form",
                                                   modal_body_locals: { workspace: @workspace }
                                                 })
      end
    end
  end

  # POST /workspaces
  def create
    @workspace = Workspace.new(workspace_params)
    @workspace.workspace_users.build(user: @current_user, role: WorkspaceUser.roles[:owner])
    if @workspace.save
      redirect_to @workspace, notice: t(".messages.created")
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("modal",
                                                   partial: "shared/modal",
                                                   locals: {
                                                     title: "새 작업공간",
                                                     modal_body_partial: "workspaces/form",
                                                     modal_body_locals: { workspace: @workspace }
                                                   }),
                 status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /workspaces/1
  def update
    if @workspace.update(workspace_params)
      redirect_to @workspace, notice: t(".messages.updated"), status: :see_other
    else
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("modal",
                                                   partial: "shared/modal",
                                                   locals: {
                                                     title: "작업공간 수정",
                                                     modal_body_partial: "workspaces/form",
                                                     modal_body_locals: { workspace: @workspace }
                                                   }),
                 status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /workspaces/1
  def destroy
    @workspace.destroy!
    redirect_to root_path, notice: t(".messages.destroyed"), status: :see_other
  end

  private

  # Only allow a list of trusted parameters through.
  def workspace_params
    params.require(:workspace).permit(:name)
  end
end
