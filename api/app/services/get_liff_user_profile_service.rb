class GetLiffUserProfileService
  require 'net/http'
  require 'uri'
  require 'json'

  def initialize(access_token, channel_id)
    @access_token = access_token
    @channel_id = channel_id
  end

  def call
    uri = URI.parse('https://api.line.me/v2/profile')

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri.path)
    request['Authorization'] = "Bearer #{@access_token}"

    res = http.request(request)

    return { error: 'Failed to verify access token', status: :unprocessable_entity } unless res.is_a?(Net::HTTPSuccess)

    body = JSON.parse(res.body)

    return { error: body['error_description'], status: :unprocessable_entity } if body['error']

    { line_user_id: body['userId'], status: :ok }
  end
end
