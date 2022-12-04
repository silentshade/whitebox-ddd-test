require 'rails_helper'

RSpec.describe Notifications::TaskMailer do
  let(:email) { 'example@example.com' }
  let(:message) { 'Test message' }
  describe '#task_assgined' do
    let(:mail) { described_class.task_assigned(email:, message:) }
    it 'renders headers' do
      expect(mail.to).to eq([email])
      expect(mail.from).to eq(["from@example.com"])
      expect(mail.subject).to eq('Task assigned')
    end

    it 'renders body' do
      expect(mail.body.encoded).to match(message)
    end
  end
end
