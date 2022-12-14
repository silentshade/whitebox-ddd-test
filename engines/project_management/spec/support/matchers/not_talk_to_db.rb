require 'rspec/expectations'

RSpec::Matchers.define :not_talk_to_db do |_expected|
  match do |block_to_test|
    %w(exec_delete exec_insert exec_query exec_update).each do |meth|
      expect(ActiveRecord::Base.connection).not_to receive(meth)
    end
    block_to_test.call
  end

  description do
    "RSpec matcher for N+1 queries"
  end

  supports_block_expectations
end
