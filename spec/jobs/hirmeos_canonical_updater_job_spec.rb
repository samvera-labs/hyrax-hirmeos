# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Hyrax::Hirmeos::HirmeosCanonicalUpdaterJob do
  let(:work) { create(:work) }

  describe '#perform' do
    let(:service) { instance_double(Hyrax::Hirmeos::MetricsTracker, patch_canonical_identifier: true) }

    before do
      allow(Hyrax::Hirmeos::MetricsTracker).to receive(:new).and_return(service)
    end

    it "makes a call to hirmeos" do
      described_class.perform_now(work.id)
      expect(service).to have_received(:patch_canonical_identifier).with(work.id)
    end
  end
end
