module ProjectManagement
  class AssigneesForTaskQuery < ::DryService
    option :task_id

    def call
      Assignee.where(task_id: task_id)
    end
  end
end
