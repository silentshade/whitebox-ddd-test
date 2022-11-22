module ProjectManagement
  class AssigneesController < ApplicationController
    def destroy
      result = DestroyAssigneeCommand.call(assignee_id: params[:id])
      if result.success?
        flash.now[:success] = 'Assignee removed from task'
      else
        flash.now[:error] = command.failure
      end

      redirect_to project_management_project_path(id: params[:project_id])
    end
  end
end
