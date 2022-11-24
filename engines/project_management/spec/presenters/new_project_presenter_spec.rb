require 'rails_helper'

RSpec.describe ProjectManagement::NewProjectPresenter do
  describe '#project' do
    context 'when params given' do
      let(:params) { FactoryBot.attributes_for(:project).slice('title', 'description') }
      it 'returns new Project with given params' do
        expect(described_class.new(params: params).project).to have_attributes(params)
      end
    end

    context 'when params are not given' do
      it 'returns new Project without attributes set' do
        expect(described_class.new.project).to have_attributes({ title: nil, description: nil, identifier: nil})
      end
    end
  end
end
