module ProjectManagement
  class Task < ApplicationRecord
    include ActiveModel::Validations
    validates_with IdentifierValidator

    validates :title, presence: true

    has_many :assignees, class_name: 'ProjectManagement::Assignee'
  end
end
