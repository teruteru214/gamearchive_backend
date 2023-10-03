class LineStackedGameService
  def initialize(user, game)
    @user = user
    @game = game
  end

  def generate_flex_message
    {
      "type": "bubble",
      "header": {
        "type": 'box',
        "layout": 'vertical',
        "contents": [
          {
            "type": 'text',
            "text": "そろそろプレイしませんか？",
            "weight": "bold",
            "size": "xl",
            "wrap": true
          }
        ]
      },
      "hero": {
        "type": "image",
        "url": @game.cover || "https://images.igdb.com/igdb/image/upload/t_cover_big/nocover.png",
        "size": "full",
        "aspectRatio": "20:13",
        "aspectMode": "fit",
        "action": {
          "type": "uri",
          "uri": "#{@game.url}"
        }
      },
      "body": {
        "type": "box",
        "layout": "vertical",
        "contents": [
          {
            "type": "text",
            "text": "#{@game.title}",
            "weight": "bold",
            "size": "xl",
            "wrap": true
          },
          {
            "type": "box",
            "layout": "vertical",
            "margin": "lg",
            "spacing": "sm",
            "contents": [
              {
                "type": "box",
                "layout": "baseline",
                "spacing": "sm",
                "contents": [
                  {
                    "type": "text",
                    "text": "Rating: #{@game.rating || 'None'}",
                    "wrap": true,
                    "color": "#666666",
                    "size": "md",
                    "flex": 5
                  }
                ]
              }
            ]
          }
        ]
      },
      "footer": {
        "type": "box",
        "layout": "vertical",
        "spacing": "sm",
        "contents": [
          {
            "type": "button",
            "style": "link",
            "height": "sm",
            "action": {
              "type": "uri",
              "label": "詳細を見る",
              "uri": "#{@game.url}"
            }
          }
        ]
      }
    }
  end
end
