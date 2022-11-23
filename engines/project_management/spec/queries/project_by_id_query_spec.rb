require 'rails_helper'

RSpec.describe ProjectManagement::ProjectByIdQuery do
  subject { described_class }

  context 'when project exists for given project_id' do
    let(:project) { FactoryBot.create(:project) }
    let(:project_id) { project.id }
    let(:result) { subject.call(project_id:) }

    it 'returns success with found project' do
      expect(result).to be_success
      expect(result.success).to eq(project)
    end
  end

  context 'when project doesnt exists for given project_id' do
    let(:result) { subject.call(project_id: 10) }
    it 'returns success with "Project not found" message' do
      expect(result).to be_failure
      expect(result.failure).to eq('Project not found')
    end
  end
end
