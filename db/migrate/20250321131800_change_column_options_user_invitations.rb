class ChangeColumnOptionsUserInvitations < ActiveRecord::Migration[8.0]
  def change
    change_column :user_invitations, :message, :string, default: nil
    change_column_null :user_invitations, :invitee_id, true
  end
end
