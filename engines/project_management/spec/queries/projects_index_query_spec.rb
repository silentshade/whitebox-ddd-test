require 'rails_helper'

RSpec.describe ProjectManagement::ProjectsIndexQuery do
  subject { described_class }
  let(:user_identifier) { SecureRandom.uuid }
  let(:projects) { FactoryBot.create_list(:project, 2, user_identifier:) }

  context 'when there are projects for given user_identifier' do
    it 'returns projects for given user identifier_identifier' do
      expect(subject.call(user_identifier:)).to eq(projects)
    end
  end

  context 'when there are no projects' do
    it 'returns empty result' do
      expect(subject.call(user_identifier: SecureRandom.uuid)).to be_empty
    end
  end
end
