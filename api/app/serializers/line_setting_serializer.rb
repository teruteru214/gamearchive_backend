class LineSettingSerializer
  include JSONAPI::Serializer
  attributes :id, :line_notification, :stacked_notification_interval
end
