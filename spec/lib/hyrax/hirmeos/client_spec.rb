# frozen_string_literal: true

require 'hyrax/hirmeos/client'
require 'jwt'

RSpec.describe Hyrax::Hirmeos::Client do
  subject(:client) do
    described_class.new(username: Hyrax::Hirmeos::MetricsTracker.username,
                        password: Hyrax::Hirmeos::MetricsTracker.password,
                        secret: Hyrax::Hirmeos::MetricsTracker.secret,
                        translation_base_url: Hyrax::Hirmeos::MetricsTracker.translation_base_url,
                        token_base_url: Hyrax::Hirmeos::MetricsTracker.token_base_url)
  end
  let(:work) { create(:work) }

  describe '#post_resource' do
    it "Makes a call to the translation api works endpoint" do
      client.post_resource(work)
      expect(a_request(:post, "#{Hyrax::Hirmeos::MetricsTracker.translation_base_url}/works")).to have_been_made.at_least_once
    end
  end

  describe '#get_resource' do
    it 'Makes a call to get the work' do
      client.get_resource(work.id)
      expect(a_request(:get, "#{Hyrax::Hirmeos::MetricsTracker.translation_base_url}/translate?uri=urn:uuid:#{work.id}")).to have_been_made.at_least_once
    end
  end

  describe '#post_file' do
    it 'Makes a call to the uris endpoint' do
      data = {
        'UUID': '48b61e0a-f92c-4533-8270-b4caa98cbcfb',
        'URI': 'localhost:3000/downloads/1234567'
      }
      client.post_file_links(data)
      expect(a_request(:post, "#{Hyrax::Hirmeos::MetricsTracker.translation_base_url}/uris").with(body: '{"UUID":"48b61e0a-f92c-4533-8270-b4caa98cbcfb","URI":"localhost:3000/downloads/1234567"}')).to have_been_made.at_least_once # rubocop:disable Layout/LineLength
    end
  end

  describe '#delete_work' do
    before do
      stub_request(:delete, "https://translator.example.com/works?uuid=urn:uuid:123")
    end

    it 'Makes a call to get the work' do
      client.delete_work("123")
      expect(a_request(:delete, "#{Hyrax::Hirmeos::MetricsTracker.translation_base_url}/works?uuid=urn:uuid:123")).to have_been_made.at_least_once
    end
  end

  describe '#patch_canonical_identifier' do
    before do
      stub_request(:patch, "https://translator.example.com/uris?UUID=48b61e0a-f92c-4533-8270-b4caa98cbcfb&URI=urn:uuid:#{work.id}&canonical=true")
    end
    it 'sends a patch request to update the UUID as the canonical identifier' do
      client.patch_canonical_identifier('48b61e0a-f92c-4533-8270-b4caa98cbcfb', work.id)
      expect(a_request(:patch, "#{Hyrax::Hirmeos::MetricsTracker.translation_base_url}/uris?UUID=48b61e0a-f92c-4533-8270-b4caa98cbcfb&URI=urn:uuid:#{work.id}&canonical=true")).to have_been_made.at_least_once
    end
  end

  describe '#request_token' do
    it 'makes a call to the token base url' do
      token = client.request_token
      expect(a_request(:post, "#{Hyrax::Hirmeos::MetricsTracker.token_base_url}/tokens")).to have_been_made.at_least_once
      expect(token).to eq("exampleToken")
    end
  end
end
