class CreateProjectManagementAssignee < ActiveRecord::Migration[7.0]
  def change
    create_table :project_management_assignees do |t|
      t.string :user_identifier
      t.string :email
      t.references :task, null: false, foreign_key: { to_table: :project_management_tasks, on_delete: :cascade }

      t.timestamps
    end
    add_index :project_management_assignees, %i[user_identifier task_id], name: 'index_assignees_on_uid_and_task'
    add_index :project_management_assignees, :email
  end
end
