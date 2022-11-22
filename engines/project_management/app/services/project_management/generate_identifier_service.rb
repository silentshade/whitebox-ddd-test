module ProjectManagement
  class GenerateIdentifierService < ::DryService
    option :entity_class

    def call
      identifier = generate_identifier

      Success(identifier)
    rescue StandardError => e
      Failure(e.message)
    end

    private

    def generate_identifier
      [entity_class.model_name.human.first(2).upcase, '-', serial].join
    end

    def serial
      sql = <<~SQL
        SELECT nextval(pg_get_serial_sequence('#{entity_class.table_name}', '#{entity_class.primary_key}')) AS serial
      SQL

      val = ActiveRecord::Base.connection.execute(Arel.sql(sql)).first['serial']

      sprintf('%04d', val)
    end
  end
end
