module ProjectManagement
  class CreateTaskCommand < ::DryService
    option :project_id
    option :task_attrs, default: ->{{}}

    def call
      identifier = yield task_identifier
      task = yield init_task(identifier)
      result = yield save_task(task)

      Success(result)
    end

    private

    def task_identifier
      result = GenerateIdentifierService.call(entity_class: Task)
      return Success(result.success) if result.success?

      Failure(result.failure)
    end

    def init_task(identifier)
      task = Task.new(**task_attrs.merge(identifier:, project_id:))
      Success(task)
    end

    def save_task(task)
      return Success(task) if task.save

      Failure(task.errors.full_messages.join(', '))
    end
  end
end
