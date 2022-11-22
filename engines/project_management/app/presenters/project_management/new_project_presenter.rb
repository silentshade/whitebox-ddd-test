module ProjectManagement
  class NewProjectPresenter
    attr_reader :params

    def initialize(params: {})
      @params = params
    end

    def project
      Project.new **params
    end
  end
end
