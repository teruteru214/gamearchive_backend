class LineFavoriteGameService
  def initialize(user, game)
    @user = user
    @game = game
  end

  def generate_flex_message
    {
      type: "bubble",
      header: {
        type: 'box',
        layout: 'vertical',
        contents: [
          {
            type: 'text',
            text: "#{user_name}さんのお気に入りのゲーム",
            weight: "bold",
            size: "xl",
            wrap: true
          }
        ]
      },
      hero: {
        type: "image",
        url: @game.cover,
        size: "full",
        aspectRatio: "20:13",
        aspectMode: "cover",
        action: {
          type: "uri",
          uri: @game.url
        }
      },
      body: {
        type: "box",
        layout: "vertical",
        contents: [
          {
            type: "text",
            text: @game.title,
            weight: "bold",
            size: "xl",
            wrap: true
          },
          {
            type: "text",
            text: "Rating: #{@game.rating}",
            wrap: true,
            color: "#666666",
            size: "md"
          }
        ]
      },
      footer: {
        type: "box",
        layout: "vertical",
        spacing: "sm",
        contents: [
          {
            type: "button",
            style: "link",
            height: "sm",
            action: {
              type: "uri",
              label: "詳細を見る",
              uri: @game.url
            }
          }
        ],
        flex: 0
      }
    }
  end

  private

  def user_name
    @user.nickname || @user.name
  end
end
