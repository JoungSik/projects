class ChangeColumnTasksDescription < ActiveRecord::Migration[8.0]
  def up
    Task.find_each do |task|
      if task.attributes['description'].present?
        task.update(description: task.attributes['description'])
      end
    end

    remove_column :tasks, :description
  end

  def down
    add_column :tasks, :description, :text unless column_exists?(:tasks, :description)

    Task.find_each do |task|
      if task.description.present? && task.description.body.present?
        plain_text = task.description.body.to_plain_text
        task.update_column(:description, plain_text)
      end
    end
  end
end
