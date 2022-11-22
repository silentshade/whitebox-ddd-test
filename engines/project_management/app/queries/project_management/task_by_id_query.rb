# frozen_string_literal: true

module ProjectManagement
  class TaskByIdQuery < ::DryService
    option :task_id

    def call
      task = Task.find_by(id: task_id)
      return Success(task) if task

      Failure('Task not found')
    end
  end
end
