require 'rails_helper'

RSpec.describe Sessions::OldSessionsRemoverJob, type: :job do
  let(:sessions_remover) { instance_double(Sessions::OldSessionsRemover, call: true) }

  before do
    allow(Sessions::OldSessionsRemover).to receive(:new).and_return(sessions_remover)
    described_class.perform_now
  end

  it 'calls the sessions remover once' do
    expect(sessions_remover).to have_received(:call).once
  end
end
