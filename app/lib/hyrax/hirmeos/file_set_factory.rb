# frozen_string_literal: true
require "hyrax/hirmeos/client"

class Hyrax::Hirmeos::FileSetFactory
  def self.for(resource:)
    file_set = Hyrax::Hirmeos::Client::FileSet.new
    file_set.title = resource.title
    file_set.uri = [{ uri: resource_url(resource) },
                    { uri: "urn:uuid:#{resource.id}", canonical: true }]
    file_set.type = "repository-file"
    file_set
  end

  def self.resource_url(file_set)
    Hyrax::Engine.routes.url_helpers.download_url(id: file_set)
  end
end
