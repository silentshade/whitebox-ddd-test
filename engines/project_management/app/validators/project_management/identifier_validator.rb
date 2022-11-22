module ProjectManagement
  class IdentifierValidator < ActiveModel::Validator
    def validate(record)
      record.errors.add(:identifier, 'must exist') if record.identifier.nil?
      record.errors.add(:identifier, 'already taken') if record.class.exists?(record.identifier)
      record.errors.add(:identifier, 'is in invalid format') unless record.identifier.to_s.match(/\w{2}-\d{4}/)
    end
  end
end
