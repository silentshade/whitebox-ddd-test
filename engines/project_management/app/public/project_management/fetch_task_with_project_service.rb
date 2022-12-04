module ProjectManagement
  class FetchTaskWithProjectService < ::DryService
    option :identifier, reader: :private

    def call
      task = yield TaskByIdentifierQuery.call(identifier:)
      project = yield ProjectByIdQuery.call(project_id: task.project_id)

      Success({task:, project:})
    end
  end
end
