class WorkspaceUser < ApplicationRecord
  belongs_to :user
  belongs_to :workspace

  enum :role, { owner: 0, member: 1 }, default: :member

  ROLE_DEFAULT = roles[:member]
end
