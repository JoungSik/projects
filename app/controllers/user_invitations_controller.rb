class UserInvitationsController < ApplicationController
  before_action :set_user_invitation, only: %i[ update destroy ]

  # GET /user_invitations
  def index
    @user_invitations = @current_user.sent_user_invitations
                                     .order(user_invitations: { invited_at: :desc })
  end

  # GET /user_invitations/new
  def new
    @user_invitation = UserInvitation.new
  end

  # POST /user_invitations
  def create
    @user_invitation = UserInvitation.new(user_invitation_params)
    if @user_invitation.save
      InvitationMailer.invite(@user_invitation).deliver_now
      redirect_to user_invitations_path, notice: t("user_invitations.messages.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /user_invitations/1
  def update
    if @user_invitation.update(user_invitation_params)
      redirect_to user_invitations_path, notice: t("user_invitations.messages.updated"), status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /user_invitations/1
  def destroy
    @user_invitation.destroy!
    redirect_to user_invitations_path, notice: t("user_invitations.messages.destroyed"), status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user_invitation
    @user_invitation = UserInvitation.find_by(id: params.expect(:id), inviter: @current_user)
  end

  # Only allow a list of trusted parameters through.
  def user_invitation_params
    params.require(:user_invitation).permit(:invitee_email, :invited_at, :message, :invitee_id, :expires_at, :status)
          .merge!(inviter: @current_user)
  end
end
