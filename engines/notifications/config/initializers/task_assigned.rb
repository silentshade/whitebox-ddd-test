Rails.application.reloader.to_prepare do
  ActiveSupport::Notifications.subscribe('project_management_domain_event.task_assigned') do |event|
    result = Notifications::AssigneeNotificationService.call(payload: event.payload)
    Rails.logger.info result
  end
end
