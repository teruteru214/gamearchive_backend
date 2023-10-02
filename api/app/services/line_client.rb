require 'line/bot'

class LineClient
  def initialize
    @client = Line::Bot::Client.new do |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    end
  end

  def push_flex_message(user_id, alt_text, contents)
    message = {
      type: 'flex',
      altText: alt_text,
      contents: contents
    }
    @client.push_message(user_id, message)
  end
end
