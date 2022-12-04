module Notifications
  class AssigneeNotificationService < ::DryService
    option :payload, reader: :private

    def call
      assignee_identifier, assigner_identifier, task_identifier = yield parse_payload(payload)
      assignee, assigner = yield fetch_users(assignee_identifier, assigner_identifier)
      task, project = yield fetch_task_and_project(task_identifier)
      message = yield compose_message(assigner, assignee, task.title, project.title)
      result = yield send_message(assignee.email, message)

      Success(result)
    end

    private

    def parse_payload(payload)
      values = payload.fetch_values(:assignee_identifier, :assigner_identifier, :task_identifier)
      return Success(values) if values.compact.size == 3

      Failure('Payload is not valid')
    rescue StandardError => _e
      Failure('Payload is not valid')
    end

    def fetch_users(assignee_identifier, assigner_identifier)
      result = UserAccess::FetchByIdentifiersService.call(identifiers: [assignee_identifier, assigner_identifier])
      return Success(result) if result.compact.size == 2

      Failure('User not found')
    end

    def fetch_task_and_project(identifier)
      result = ProjectManagement::FetchTaskWithProjectService.call(identifier:)
      return Failure(result.failure) if result.failure?

      Success(result.success.fetch_values(:task, :project))
    end

    def compose_message(assigner, assignee, task_title, project_title)
      message = <<~STR.strip
        Hello #{assignee.first_name} #{assignee.last_name},
        #{assigner.first_name} #{assigner.last_name} assigned a task "#{task_title}" for you
        in project "#{project_title}"
      STR

      Success(message)
    end

    def send_message(email, message)
      result = TaskMailer.task_assigned(email:, message:).deliver_later
      return Success(result) if result

      Failure('Unable to enqueue email notification')
    end
  end
end
