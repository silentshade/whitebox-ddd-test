require 'rails_helper'

RSpec.describe ProjectManagement::CreateTaskCommand do
  subject { described_class }

  let(:task_attrs) { { title: 'Test task', description: 'Description' } }
  let(:project) { FactoryBot.create :project }
  let(:options) { {task_attrs:, project_id: project.id } }

  context 'when all requires attrs passed' do
    it 'returns success result' do
      expect(subject.call(**options)).to be_success
    end

    it 'creates task' do
      expect{ subject.call(**options) }.to change(ProjectManagement::Task, :count).by(1)
    end

    it 'sets correct attributes for created task' do
      result = subject.call(**options)
      expect(result.success.attributes.symbolize_keys).to include(**task_attrs, project_id: project.id)
    end

    it 'generates correct identifier' do
      result = subject.call(**options)
      expect(result.success.identifier).to match(/TA-\d{4}/)
    end
  end

  context 'when one of requires attrs not passed' do
    let(:task_attrs) { { description: 'Description' } }

    it 'returns failure result' do
      expect(subject.call(**options)).to be_failure
    end

    it 'doesnt create task' do
      expect{ subject.call(**options) }.to change(ProjectManagement::Task, :count).by(0)
    end
  end
end
