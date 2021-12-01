# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Hyrax::Hirmeos::HirmeosFileSetRegistrationJob do
  let(:file_set) { create(:file_with_work) }

  describe '#perform' do
    it "makes a call to hirmeos" do
      body = "{\"count\": 14, \"code\": 200, \"data\": [{\"URI\": \"https://dashboard.bertie.ubiquityrepo-ah.website/concern/pacific_images/92cfa1e1-4ab3-4fd3-9140-90eda7cd5ed9\", \"canonical\": true, \"score\": 0, \"URI_parts\": {\"scheme\": \"https\", \"value\": \"dashboard.bertie.ubiquityrepo-ah.website/concern/pacific_images/92cfa1e1-4ab3-4fd3-9140-90eda7cd5ed9\"}, \"work\": {\"URI\": [], \"type\": \"repository-work\", \"title\": [\"Pictures of TWICE\"], \"UUID\": \"48b61e0a-f92c-4533-8270-b4caa98cbcfb\"}}]}"
      stub_request(:get, "#{Hyrax::Hirmeos::MetricsTracker.translation_base_url}/translate?uri=urn:uuid:#{file_set.id}").to_return(status: 200, body: body)
      described_class.perform_now(file_set.id)
      expect(a_request(:post, "#{Hyrax::Hirmeos::MetricsTracker.translation_base_url}/works")).to have_been_made.at_least_once
    end
  end
end
