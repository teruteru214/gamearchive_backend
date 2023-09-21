class LineSettingSerializer
  include JSONAPI::Serializer
  attributes :line_user_id, :line_notification, :stacked_notification_interval, :favorite_notification_interval
end
