require File.expand_path(File.dirname(__FILE__) + "/environment")

set :output, "log/cron.log"

every 1.day, at: '12:00 pm' do
  runner "LineSetting.notify_users"
end
