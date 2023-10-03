#!/bin/bash

# cronをバックグラウンドで起動
service cron start

# `whenever` gemの設定を読み込み、cronにジョブを設定
# (必要であれば、以下のコマンドを追加します)
# bundle exec whenever --update-crontab

# Railsサーバーを起動
bundle exec rails s -p 3000 -b '0.0.0.0'
