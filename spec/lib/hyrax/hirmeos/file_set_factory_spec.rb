# frozen_string_literal: true
require 'hyrax/hirmeos/work_factory'
require 'hyrax/hirmeos/client'
require 'rails_helper'

RSpec.describe Hyrax::Hirmeos::FileSetFactory do
  WebMock.allow_net_connect!
  let(:file) { create(:file_with_work) }

  it "Creates works with the correct structure" do
    structure = {
      title: [
        file.title[0].to_s
      ],
      uri: [
        {
          uri: "https://localhost:3000/downloads/#{file.id}"
        },
        {
          uri: "urn:uuid:#{file.id}",
          canonical: true
        }
      ],
      type: "repository-file",
      parent: nil,
      children: nil
    }
    factory_file = described_class.for(resource: file)
    expect(factory_file.to_json).to eq(structure.to_json)
  end
end
