class UserInvitationsController < ApplicationController
  before_action :set_user_invitation, only: %i[ update destroy ]

  # GET /user_invitations
  def index
    @user_invitations = @current_user.sent_user_invitations
                                     .order(user_invitations: { invited_at: :desc })
  end

  # GET /user_invitations/new
  def new
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("modal",
                                                 partial: "shared/modal",
                                                 locals: {
                                                   title: "초대하기",
                                                   modal_body_partial: "user_invitations/form",
                                                   modal_body_locals: { user_invitation: UserInvitation.new }
                                                 })
      end
    end
  end

  # POST /user_invitations
  def create
    @user_invitation = UserInvitation.new(user_invitation_params)
    if @user_invitation.try(:save)
      redirect_to user_invitations_path, notice: t("user_invitations.messages.created")
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("modal",
                                                   partial: "shared/modal",
                                                   locals: {
                                                     title: "초대하기",
                                                     modal_body_partial: "user_invitations/form",
                                                     modal_body_locals: { user_invitation: @user_invitation }
                                                   }),
                 status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /user_invitations/1
  def update
    if @user_invitation.try(:update, user_invitation_params)
      redirect_to user_invitations_path, notice: t("user_invitations.messages.updated"), status: :see_other
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("modal",
                                                   partial: "shared/modal",
                                                   locals: {
                                                     title: "초대하기",
                                                     modal_body_partial: "user_invitations/form",
                                                     modal_body_locals: { user_invitation: @user_invitation }
                                                   }),
                 status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /user_invitations/1
  def destroy
    @user_invitation.try!(destroy)
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
