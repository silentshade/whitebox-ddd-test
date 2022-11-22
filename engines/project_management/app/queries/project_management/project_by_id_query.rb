# frozen_string_literal: true

module ProjectManagement
  class ProjectByIdQuery < ::DryService
    option :project_id

    def call
      project = Project.find_by(id: project_id)
      return Success(project) if project

      Failure('Project not found')
    end
  end
end
