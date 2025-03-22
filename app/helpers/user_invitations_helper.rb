module UserInvitationsHelper

  # class="bg-yellow-100 text-yellow-800"
  # class="bg-green-100 text-green-800"
  # class="bg-red-100 text-red-800""
  def user_invitation_status_color(user_invitation)
    case user_invitation.status_before_type_cast
    when 0 then "yellow"
    when 1 then "green"
    when 2 then "red"
    else "yellow"
    end
  end
end
