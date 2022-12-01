namespace :project_management do
  task delete_unassigned_tasks: :environment do
    ProjectManagement::DeleteUnassignedTasksService.call
  end
end
