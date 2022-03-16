# frozen_string_literal: true

class Hyrax::Hirmeos::Client
  attr_accessor :username, :password, :metrics_base_url, :translation_base_url,
  :token_base_url, :secret

  def initialize(username, password, metrics_base_url, translation_base_url, token_base_url, secret)
    @username = username
    @password = password
    @metrics_base_url = metrics_base_url
    @translation_base_url = translation_base_url
    @token_base_url = token_base_url
    @secret = secret
  end

  def post_resource(resource)
    id_translation_connection.post('/works', resource.to_json)
  end

  def get_resource(hyku_uuid)
    id_translation_connection.get("/translate?uri=urn:uuid:#{hyku_uuid}")
  end

  def get_resource_identifiers(hirmeos_uuid)
    id_translation_connection.get("/works?uuid=#{hirmeos_uuid}")
  end

  def delete_work(hirmeos_uuid)
    id_translation_connection.delete('/works', uuid: "urn:uuid:#{hirmeos_uuid}")
  end

  def post_file_links(data)
    id_translation_connection.post('/uris', data.to_json)
  end

  def patch_canonical_identifier(hirmeos_uuid, hyku_uuid)
    id_translation_connection.patch("/uris?UUID=#{hirmeos_uuid}&URI=urn:uuid:#{hyku_uuid}&canonical=true")
  end

  def request_token
    response = Faraday.post(URI.join(token_base_url, 'tokens'), { email: username, password: password }.to_json)
    JSON.parse(response.body)['data'][0]['token']
  end

  Work = Struct.new(:title, :uri, :type, :parent, :children)
  FileSet = Struct.new(:title, :uri, :type, :parent, :children)

  private

  def id_translation_connection
    connection_for(translation_base_url)
  end

  def metrics_connection
    connection_for(metrics_base_url)
  end

  def connection_for(url)
    Faraday.new(url) do |conn|
      conn.adapter Faraday.default_adapter # net/http
      conn.token_auth(request_token)
    end
  end
end
