module ProjectManagement
  class NewTaskPresenter
    attr_reader :params

    def initialize(params: {})
      @params = params
    end

    def task
      Task.new **params
    end
  end
end
