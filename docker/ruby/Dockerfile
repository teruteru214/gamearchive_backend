# FROMでベースイメージを設定
# 今回はRubyのバージョン3.1.2をベースイメージとして設定
FROM ruby:3.1.2
# nodeやyarn等の必要なライブラリをインストール
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs cron

ENV APP_ROOT /var/www

# Railsアプリを配置するフォルダをコンテナ内に作成
RUN mkdir -p $APP_ROOT
# 作成したディレクトリをワークディレクトリとして設定
WORKDIR $APP_ROOT

# アプリディレクトリ配下のGemfileをコンテナ内のRailsアプリの配置場所にコピー
COPY ./Gemfile $APP_ROOT/Gemfile
# Gemfile.lockも同様にコンテナ内にコピーする
COPY ./Gemfile.lock $APP_ROOT/Gemfile.lock
# Gemfileの記述を元にbundle installを実行
RUN bundle install

# 現在のディレクトリをコンテナ内にコピー
COPY . $APP_ROOT

# コンテナ起動時に実行させるスクリプトを追加
# アクセス権限を実行可能にしておく
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# start.shをDockerコンテナにコピー
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Rails サーバ起動
CMD ["rails", "server", "-b", "0.0.0.0"]
