class UsersController < ApplicationController
  before_action :set_user, only: %i[ edit update destroy ]

  before_action :require_user_invitation_token, only: %i[ new create ]
  allow_unauthenticated_access only: %i[ new create ]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save && @user_invitation.update(invitee: @user, status: :accepted)
      redirect_to login_path, notice: t(".messages.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /users/1/edit
  def edit
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      redirect_to edit_user_path(@user), notice: t(".messages.updated"), status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy!
    redirect_to root_path, notice: t(".messages.destroyed"), status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params.expect(:id))
  end

  def require_user_invitation_token
    @user_invitation = UserInvitation.find_by(token: params[:token])
    redirect_to root_path, notice: t(".messages.error_token") if @user_invitation.blank?
    redirect_to root_path, notice: t(".messages.error_token") unless @user_invitation.pending?
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
