class InvitationMailer < ApplicationMailer

  def invite(user_invitation)
    @user_invitation = user_invitation
    mail subject: t("email.invitation.invite.subject", app_name: t("app.name")), to: user_invitation.invitee_email
  end
end
