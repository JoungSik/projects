class User < ApplicationRecord
  has_secure_password

  has_many :sessions, dependent: :destroy
  has_many :workspace_users
  has_many :workspaces, through: :workspace_users

  normalizes :email, with: ->(e) { e.strip.downcase }

  validates_presence_of :name
end
