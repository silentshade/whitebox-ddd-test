require 'rails_helper'

RSpec.describe ProjectManagement::ProjectsIndexPresenter do
  context 'when current_user_identifier argument passed' do
    let(:current_user_identifier) { SecureRandom.uuid }

    subject { described_class.new(current_user_identifier:) }

    describe '#projects' do
      it 'calls ProjectsIndexQuery with given current_user_identifier' do
        expect(ProjectManagement::ProjectsIndexQuery).to receive(:call).with(user_identifier: current_user_identifier)
        subject.projects
      end
    end
  end

  context 'when current_user_identifier argument is not passed' do
    it 'raises ArgumentError' do
      expect { described_class.new }.to raise_error(ArgumentError)
    end
  end
end
