# frozen_string_literal: true

module ProjectManagement
  class TaskByIdentifierQuery < ::DryService
    option :identifier, reader: :private

    def call
      task = Task.find_by(identifier:)
      return Success(task) if task

      Failure('Task not found')
    end
  end
end
