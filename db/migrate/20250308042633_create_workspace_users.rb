class CreateWorkspaceUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :workspace_users do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :workspace, null: false, foreign_key: true
      t.integer :role, null: false, default: WorkspaceUser::ROLE_DEFAULT

      t.timestamps
    end
  end
end
