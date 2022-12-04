module Notifications
  class TaskMailer < ApplicationMailer

    def task_assigned(email:, message:)
      @message = message
      mail(to: email, subject: 'Task assigned')
    end
  end
end
