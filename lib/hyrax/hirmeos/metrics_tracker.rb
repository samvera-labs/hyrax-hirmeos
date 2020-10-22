# frozen_string_literal: true
require "hyrax/hirmeos/client"
require "hyrax/hirmeos/work_factory"
class Hyrax::Hirmeos::MetricsTracker

  attr_accessor :username, :password, :metrics_base_url, :token_base_url, :translation_base_url, :client

  def initialize(username, password, metrics_base_url, token_base_url, translation_base_url)
    @username = username
    @password = password
    @metrics_base_url = metrics_base_url
    @token_base_url = token_base_url
    @translation_base_url = translation_base_url
  end

  def client
    @client ||= Hyrax::Hirmeos::Client.new(self.username, @password, @metrics_base_url, @token_base_url, @translation_base_url)
  end

  def submit_to_hirmeos(work)
    uuid = work.id
    response = client.get_work(uuid)
    unless response.success?
      client.post_work(work: resource_to_hirmeos_json(work))
    end
  end

  def resource_to_hirmeos_json(work)
    Hyrax::Hirmeos::WorkFactory.for(resource: work)
  end
end