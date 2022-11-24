module ProjectManagement
  class TasksController < ApplicationController
    def index
      @presenter = TasksIndexPresenter.new(current_user_identifier:)
    end

    def new
      @presenter = NewTaskPresenter.new
    end

    def create
      result = CreateTaskCommand.new(task_attrs: task_params, project_id: params[:project_id]).call
      if result.failure?
        @presenter = NewTaskPresenter.new(params: task_params)
        flash.now[:error] = result.failure

        return render :new, status: :unprocessable_entity
      end

      redirect_to project_management_project_path(id: params[:project_id])
    end

    def update
      command = UpdateTaskService.call(params: task_params)
    end

    def destroy
      result = DestroyTaskCommand.call(task_id: params[:id])
      if result.failure?
        flash[:error] = result.failure
      else
        flash[:success] = 'Task deleted'
      end

      redirect_to project_management_project_path(id: params[:project_id])
    end

    def add_assignee
      result = AssignTaskToAssigneeService.call(task_id: params[:id], user_email: params[:email])
      if result.failure?
        flash[:error] = result.failure
        return redirect_to project_management_project_path(id: params[:project_id]), status: :unprocessable_entity
      end

      task_monad = TaskByIdQuery.call(task_id: params[:id])
      @presenter = TaskRowPresenter.new(task: task_monad.success, available_users: UserAccess::AllUsersService.new.call)

      respond_to do |format|
        format.turbo_stream { flash.now[:success] = 'Assignee added' }
      end
    end

    private

    def task_params
      params.fetch(:project_management_task, {}).permit(:title, :description)
    end
  end
end
