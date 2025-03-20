class CreateUserInvitations < ActiveRecord::Migration[8.0]
  def change
    create_table :user_invitations do |t|
      t.references :inviter, null: false, foreign_key: { to_table: :users }
      t.string :invitee_email, null: false
      t.string :token, null: false
      t.datetime :invited_at, null: false
      t.text :message
      t.references :invitee, null: false, foreign_key: { to_table: :users }
      t.datetime :expires_at
      t.integer :status, default: 0, null: false

      t.timestamps
    end

    add_index :user_invitations, :invitee_email, unique: true
    add_index :user_invitations, :token, unique: true
  end
end
