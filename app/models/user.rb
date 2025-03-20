class User < ApplicationRecord
  has_secure_password

  has_many :sessions, dependent: :destroy
  has_many :workspace_users
  has_many :workspaces, through: :workspace_users

  has_many :sent_user_invitations, foreign_key: :inviter_id, class_name: "UserInvitation", dependent: :destroy

  normalizes :email, with: ->(e) { e.strip.downcase }

  validates_presence_of :name
end
