module ProjectManagement
  class ProjectsController < ApplicationController
    def index
      @presenter = ProjectsIndexPresenter.new(current_user_identifier: current_user_identifier)
    end

    def new
      @presenter = NewProjectPresenter.new(params: project_params)
    end

    def create
      result = CreateProjectCommand.call(project_attrs: project_params, user_identifier: current_user_identifier)
      if result.failure?
        @presenter = NewProjectPresenter.new(params: project_params)
        flash.now[:error] = result.failure

        return render :new, status: :unprocessable_entity
      end

      redirect_to action: :index
    end

    def show
      result = ProjectByIdQuery.call(project_id: params[:id])
      if result.failure?
        flash[:error] = result.failure
        return redirect_to action: :index
      end

      @presenter = ProjectShowPresenter.new(project: result.success)
    end

    def destroy
      result = DestroyProjectCommand.call(project_id: params[:id])
      if result.failure?
        @presenter = NewProjectPresenter.new(params: project_params)
        return redirect_to action: :index, status: :unprocessable_entity
      end

      redirect_to action: :index
    end

    def invite_user
      service = InviteUserToProjectService.call(project_identifier: , user_identifier:)
    end

    private

    def project_params
      params.fetch(:project_management_project, {}).permit(:title, :description)
    end

    def project_identifier
      params[:id]
    end

    def user_identifier
      params[:user_identifier]
    end
  end
end
