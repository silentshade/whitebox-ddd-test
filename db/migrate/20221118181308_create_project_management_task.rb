class CreateProjectManagementTask < ActiveRecord::Migration[7.0]
  def change
    create_table :project_management_tasks do |t|
      t.string :title
      t.text :description
      t.string :identifier
      t.references :project, null: false, foreign_key: { to_table: :project_management_projects, on_delete: :cascade }

      t.timestamps
    end

    add_index :project_management_tasks, :identifier, unique: true
  end
end
