# frozen_string_literal: true

require 'hyrax/hirmeos/work_factory'
require 'hyrax/hirmeos/client'

RSpec.describe Hyrax::Hirmeos::WorkFactory do
  WebMock.allow_net_connect!
  let(:work) { create(:work) }
  let(:work_with_file) { create(:work_with_one_file) }
  let(:work_with_multiple_files) { create(:work_with_files) }

  it "Creates works with the correct structure" do
    structure = {
      title: [
        work.title[0].to_s
      ],
      uri: [
        {
          uri: "https://localhost:3000/concern/generic_works/#{work.id}"
        },
        {
          uri: "urn:uuid:#{work.id}",
          canonical: true
        }
      ],
      type: "repository-work",
      parent: nil,
      children: nil
    }
    factory_work = described_class.for(resource: work)
    expect(factory_work.to_json).to eq(structure.to_json)
  end
end
