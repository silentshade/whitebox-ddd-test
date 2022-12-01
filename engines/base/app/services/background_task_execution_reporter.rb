module BackgroundTaskExecutionReporter
  extend ActiveSupport::Concern
  included do
    def execute_and_log(name)
      Thread.new do
        Rails.logger.debug "#{name} task has started"
        result = yield
        if result.failure?
          Rails.logger.error "#{name} error: #{result.error_message}"
          Rails.logger.error "#{name} backtrace: #{result.error&.backtrace}"
        end
        Rails.logger.debug "#{name} task has finished"
      end.join
    end
  end
end
