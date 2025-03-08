class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.belongs_to :project, null: false, foreign_key: true
      t.references :assign_user, null: false, foreign_key: { to_table: :users }
      t.references :creator, null: false, foreign_key: { to_table: :users }
      t.string :title, null: false
      t.text :description
      t.integer :type, null: false, default: Task::TYPE_DEFAULT
      t.integer :priority, null: false, default: Task::PRIORITY_DEFAULT
      t.integer :status, null: false, default: Task::STATUS_DEFAULT
      t.date :start_at
      t.date :end_at

      t.timestamps
    end
  end
end
