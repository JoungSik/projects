class Workspace < ApplicationRecord
  has_many :workspace_users, dependent: :destroy
  has_many :users, through: :workspace_users

  has_many :projects, dependent: :destroy

  accepts_nested_attributes_for :workspace_users

  validates_presence_of :name
end
