class Api::V1::LineMessagesController < Api::V1::BaseController

  def callback
    body = request.body.read
    events = client.parse_events_from(body)
    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          handle_text_message(event)
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

  def handle_text_message(event)
    line_client = LineClient.new

    if event.message["text"] == "他ユーザーのお気に入りゲームを教えて"
      subquery = User.joins(:favorites).where(visibility: "public").distinct.select(:id)
      user = User.where(id: subquery).order("RANDOM()").first
      game = user.favorited_games.order("RANDOM()").first if user

      if user && game
        line_message_service = LineFavoriteGameService.new(user, game)
        flex_contents = line_message_service.generate_flex_message
        line_client.push_flex_message(user.line_setting.line_user_id, "#{user.nickname}さんのお気に入りゲーム", flex_contents)
      end
    else
      message = {
        type: "text",
        text: "メッセージありがとうございます！申し訳ございませんが、現在のリクエストには個別に対応することができません。何かご質問やご要望がありましたら、こちらのXアカウント [@teruteru1237](https://twitter.com/teruteru1237) のDMでご連絡ください。🎮"
      }
      client.reply_message(event['replyToken'], message)
    end
  end
end
