require 'rails_helper'

RSpec.describe ProjectManagement::GenerateIdentifierService do
  subject { described_class }

  context 'when AR Model passed as entity_class' do
    context 'when no table exists' do
      let(:entity_class) { Object.const_set('NoTableModel', Class.new(ActiveRecord::Base)) }
      it 'returns success with new identifier' do
        expect(subject.call(entity_class:)).to be_failure
      end
    end

    context 'when table exists' do
      let(:entity_class) { ProjectManagement::Project }
      it 'returns success with new identifier' do
        expect(subject.call(entity_class:)).to be_success
      end
    end
  end

  context 'when passed entity_class doesnt respond to .table_name' do
    let(:entity_class) { Class.new(Struct.new(:model_name, keyword_init: true)).new(model_name: 'SomeModel')}

    it 'returns failure' do
      expect(subject.call(entity_class:)).to be_failure
    end
  end

  context 'when passed entity_class doesnt respond to .model_name' do
    let(:entity_class) { Class.new(Struct.new(:table_name, keyword_init: true)).new(table_name: 'some_records')}

    it 'returns failure' do
      expect(subject.call(entity_class:)).to be_failure
    end
  end

  context 'when race conditions may occur requesting identifier' do
    let(:entity_class) { ProjectManagement::Project }
    let(:results) {[]}
    let(:t1) do
      Thread.new do |_t|
        sleep 1
        results.push subject.call(entity_class:)
      end
    end

    let(:t2) do
      Thread.new do |_t|
        results.push subject.call(entity_class:)
      end
    end

    it 'returns success with unique identifier' do
      [t1, t2].each(&:join)
      results.each{|r| expect(r).to be_success }
      expect(results[0]).not_to eq(results[1])
    end
  end
end
