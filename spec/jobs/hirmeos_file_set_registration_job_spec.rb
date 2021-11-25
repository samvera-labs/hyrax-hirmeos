# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Hyrax::Hirmeos::HirmeosFileSetRegistrationJob do
  let(:file_set) { create(:file_with_work) }

  describe '#perform' do
    it "makes a call to hirmeos" do
      stub_request(:get, "#{Hyrax::Hirmeos::MetricsTracker.translation_base_url}/translate?uri=urn:uuid:#{file_set.id}").to_return(status: 400)
      described_class.perform_now(file_set.id)
      expect(a_request(:post, "#{Hyrax::Hirmeos::MetricsTracker.translation_base_url}/works")).to have_been_made.at_least_once
    end
  end
end
