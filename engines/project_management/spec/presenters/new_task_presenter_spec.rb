require 'rails_helper'

RSpec.describe ProjectManagement::NewTaskPresenter do
  describe '#task' do
    context 'when params given' do
      let(:params) { FactoryBot.attributes_for(:task).slice('title', 'description', 'project_id') }
      it 'returns new Task with given params' do
        expect(described_class.new(params: params).task).to have_attributes(params)
      end
    end

    context 'when params are not given' do
      it 'returns new Task without attributes set' do
        expect(described_class.new.task).to have_attributes({ title: nil, description: nil, project_id: nil, identifier: nil})
      end
    end
  end
end
