class GetLiffUserService
  require 'net/http'
  require 'uri'
  require 'json'

  def initialize(id_token, channel_id)
    @id_token = id_token
    @channel_id = channel_id
  end

  def call
    uri = URI.parse('https://api.line.me/oauth2/v2.1/verify')
    begin
      res = Net::HTTP.post_form(uri, 'id_token' => @id_token, 'client_id' => @channel_id)
    rescue StandardError => e
      return { error: e.message, status: :internal_server_error }
    end

    return { error: 'Failed to verify ID token', status: :unprocessable_entity } unless res.is_a?(Net::HTTPSuccess)

    body = JSON.parse(res.body)

    return { error: body['error_description'], status: :unprocessable_entity } if body['error']

    { line_user_id: body['sub'], status: :ok }
  end
end
