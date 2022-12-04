require 'rails_helper'

RSpec.describe BackgroundTaskExecutionReporter do
  subject do
    Class.new.include(described_class).new
  end

  describe '#execute_and_log' do
    context 'when execution result success' do
      let(:execute) { subject.execute_and_log('Test'){ Class.new(Struct.new(:success?, :failure?)).new(true, false) } }
      it 'prints out task started and finished messages' do
        expect(Rails.logger).to receive(:debug).with('Test task has started').ordered
        expect(Rails.logger).to receive(:debug).with('Test task has finished').ordered
        execute
      end
    end

    context 'when execution result failure' do
      let(:execute) do
        subject.execute_and_log('Test'){ Class.new(Struct.new(:success?, :failure?, :error_message, :error))
                                              .new(false, true, 'Weird error', StandardError.new) }
      end

      it 'prints out task started, finished and exception messages' do
        expect(Rails.logger).to receive(:debug).with('Test task has started').ordered
        expect(Rails.logger).to receive(:error).with('Test error: Weird error').ordered
        expect(Rails.logger).to receive(:error).with('Test backtrace: ').ordered
        expect(Rails.logger).to receive(:debug).with('Test task has finished').ordered
        execute
      end
    end
  end
end
