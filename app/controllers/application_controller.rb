class ApplicationController < ActionController::Base
  include Authentication
  include LoadResourceContext

  before_action :require_authentication

  before_action :set_workspaces, if: :authenticated?

  def set_workspaces
    @workspaces ||= @current_user.workspaces
  end
end
