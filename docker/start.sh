#!/bin/bash

# cronをバックグラウンドで起動
service cron start

# Railsサーバーを起動
bundle exec rails s -p 3000 -b '0.0.0.0'
