require 'rails_helper'

RSpec.describe ProjectManagement::CreateProjectCommand do
  subject { described_class }

  let(:project_attrs) { { title: 'Test project', description: 'Description' } }
  let(:user_identifier) { SecureRandom.uuid }
  let(:options) { {project_attrs:, user_identifier:} }

  context 'when all requires attrs passed' do
    it 'returns success result' do
      expect(subject.call(**options)).to be_success
    end

    it 'creates project' do
      expect{ subject.call(**options) }.to change(ProjectManagement::Project, :count).by(1)
    end

    it 'sets correct attributes for created project' do
      result = subject.call(**options)
      expect(result.success.attributes.symbolize_keys).to include(**project_attrs, user_identifier: user_identifier)
    end

    it 'generates correct identifier' do
      result = subject.call(**options)
      expect(result.success.identifier).to match(/PR-\d{4}/)
    end
  end

  context 'when one of requires attrs not passed' do
    let(:project_attrs) { { description: 'Description' } }

    it 'returns failure result' do
      expect(subject.call(**options)).to be_failure
    end

    it 'doesnt create project' do
      expect{ subject.call(**options) }.to change(ProjectManagement::Project, :count).by(0)
    end
  end
end
