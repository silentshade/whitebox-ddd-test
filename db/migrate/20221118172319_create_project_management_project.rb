class CreateProjectManagementProject < ActiveRecord::Migration[7.0]
  def change
    create_table :project_management_projects do |t|
      t.string :title, null: false
      t.text :description
      t.string :identifier, null: false
      t.string :user_identifier

      t.timestamps
    end

    add_index :project_management_projects, :identifier, unique: true
    add_index :project_management_projects, :user_identifier
  end
end
