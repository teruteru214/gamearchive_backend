class Api::V1::LineMessagesController < Api::V1::BaseController

  def callback
    body = request.body.read
    events = client.parse_events_from(body)
    events.each do |event|
      case event
      when Line::Bot::Event::Message
        if event.message["text"] == "他の人のお気に入りのゲームを教えて" && event.type == Line::Bot::Event::MessageType::Text
          user = User.where(visibility: "公開").order("RANDOM()").first
          game = user.games.order("RANDOM()").first if user

          if user && game
            line_message_service = LineFavoriteGameService.new(user, game)
            message = line_message_service.generate_flex_message

            client.reply_message(event['replyToken'], message)
          end
        end
      end
    end
    head :ok
  end

  private

  def client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    end
  end
end
