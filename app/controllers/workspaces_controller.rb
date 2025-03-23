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
    @workspace = Workspace.new
  end

  # GET /workspaces/1/edit
  def edit
  end

  # POST /workspaces
  def create
    @workspace = Workspace.new(workspace_params)
    @workspace.workspace_users.build(user: @current_user, role: WorkspaceUser.roles[:owner])
    if @workspace.save
      redirect_to @workspace, notice: t(".messages.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /workspaces/1
  def update
    if @workspace.update(workspace_params)
      redirect_to @workspace, notice: t(".messages.updated"), status: :see_other
    else
      render :edit, status: :unprocessable_entity
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
