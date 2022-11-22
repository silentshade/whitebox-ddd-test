module ProjectManagement
  class DestroyProjectCommand < ::DryService
    option :project_id

    def call
      result = Project.destroy(project_id)

      Success(result)
    rescue StandardError => e
      Failure(e.message)
    end
  end
end
