# frozen_string_literal: true
class Hyrax::Hirmeos::MetricsTracker
  class_attribute :username, :password, :metrics_base_url, :translation_base_url, :secret, :work_factory, :file_set_factory

  def client
    @client ||= Hyrax::Hirmeos::Client.new(username, password, metrics_base_url, translation_base_url, secret)
  end

  def submit_work_to_hirmeos(work_id, work_json)
    response = client.get_resource(work_id)
    return if response.success?
    client.post_resource(work_json)
  end

  def submit_file_set_to_hirmeos(file_set_id, file_set_json)
    response = client.get_resource(file_set_id)
    json_response = JSON.parse(response.body)
    return if file_already_registered?(json_response)
    client.post_resource(file_set_json)
  end

  def file_already_registered?(json_response)
    json_response["data"].each do |resource|
      return true if resource['work']['type'] == "repository-file"
    end
    false
  end

  def submit_file_links_to_hirmeos_work(file_set)
    work_id = file_set.parent_work_ids.first
    hirmeos_id = get_translator_work_id(work_id)
    file_set_links(file_set, hirmeos_id).each do |link|
      client.post_file_links(link)
    end
  end

  def submit_diff_to_hirmeos(work)
    hirmeos_uuid = get_translator_work_id(work.id)
    existing_hirmeos_links = get_resource_links(hirmeos_uuid)
    latest_work_links = work_to_hirmeos_json_with_files(work, hirmeos_uuid)

    diff = latest_work_links.select { |link| !exists_link_uri?(link, at: existing_hirmeos_links) }
    diff.each do |diff_entry|
      client.post_file_links("URI": diff_entry[:URI] || diff_entry[:uri], UUID: hirmeos_uuid)
    end
  end

  def get_translator_work_id(uuid)
    response = client.get_resource(uuid)
    work_json = JSON.parse(response.body) if response.success?
    work_json.dig('data', 0, 'work', 'UUID') if work_json.present?
  end

  def get_resource_links(hirmeos_uuid)
    response = client.get_resource_identifiers(hirmeos_uuid)
    JSON.parse(response.body).dig("data", 0, "URI")
  rescue
    []
  end

  def patch_canonical_identifier(uuid)
    hirmeos_uuid = get_translator_work_id(uuid)
    client.patch_canonical_identifier(hirmeos_uuid, uuid)
  end

  def work_to_hirmeos_json(work)
    work_factory.for(resource: work)
  end

  def file_set_to_hirmeos_json(file_set)
    file_set_factory.for(resource: file_set)
  end

  def work_to_hirmeos_json_with_files(work, hirmeos_uuid)
    work_links = work_factory.for(resource: work).uri
    work.file_sets.each do |file_set|
      work_links << file_set_links(file_set, hirmeos_uuid)
    end
    work_links.flatten
  end

  def file_url(file)
    Hyrax::Engine.routes.url_helpers.download_url(id: file)
  end

  def resource_to_link_update_hash(resource_url, hirmeos_id)
    { 'URI': resource_url, 'UUID': hirmeos_id }
  end

  def resource_to_uuid_update_hash(resource_id, hirmeos_id)
    { 'URI': "urn:uuid:#{resource_id}", 'UUID': hirmeos_id }
  end

  def file_set_links(file_set, hirmeos_id)
    [
      resource_to_link_update_hash(file_url(file_set), hirmeos_id),
      resource_to_uuid_update_hash(file_set.id, hirmeos_id)
    ]
  end

  private

  def exists_link_uri?(link, source_options)
    source_options.assert_valid_keys(:at)
    uri = link[:uri].presence || link[:URI]
    source_options[:at].any? { |item| uri == item["URI"] }
  end
end
