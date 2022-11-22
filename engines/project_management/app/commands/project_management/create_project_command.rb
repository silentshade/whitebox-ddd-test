module ProjectManagement
  class CreateProjectCommand < ::DryService
    option :project_attrs, default: ->{{}}
    option :user_identifier

    def call
      identifier = yield project_identifier
      project = yield init_project(identifier)
      result = yield save_project(project)

      Success(result)
    rescue StandardError => e
      Failure(e.message)
    end

    private

    def init_project(identifier)
      project = Project.new(**project_attrs.merge(user_identifier:, identifier:))
      Success(project)
    end

    def save_project(project)
      return Success(project) if project.save

      Failure(project.errors.full_messages.join(', '))
    end

    def project_identifier
      result = GenerateIdentifierService.call(entity_class: Project)
      return Success(result.success) if result.success?

      Failure(result.failure)
    end
  end
end
