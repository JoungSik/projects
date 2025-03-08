class Workspace < ApplicationRecord
  has_many :workspace_users, dependent: :destroy
  has_many :users, through: :workspace_users

  has_many :projects, dependent: :destroy

  # nested_attributes_options

  validates_presence_of :name
end
