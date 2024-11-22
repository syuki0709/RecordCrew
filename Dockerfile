# ベースイメージにRubyを指定
FROM ruby:3.1

# 必要なパッケージをインストール
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# 作業ディレクトリの作成
WORKDIR /myapp

# 必要なgemをインストールするためにGemfileをコピー
COPY Gemfile Gemfile.lock ./

# Bundlerのインストール
RUN bundle install

# アプリケーションのコードをコンテナにコピー
COPY . .

# ポート3000を開放
EXPOSE 3000

# Railsサーバーを立ち上げるコマンド
CMD ["rails", "server", "-b", "0.0.0.0"]
