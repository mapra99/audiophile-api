require 'rails_helper'

RSpec.describe Recommendations::RecommendationsBuilderJob, type: :job do
  let(:recommendations_builder) { instance_double(Recommendations::RecommendationsBuilder, call: true) }

  before do
    allow(Recommendations::RecommendationsBuilder).to receive(:new).and_return(recommendations_builder)
    create_list(:product, 10)

    described_class.perform_now
  end

  it 'calls the recommendation builder service once per product' do
    expect(recommendations_builder).to have_received(:call).exactly(10)
  end
end
