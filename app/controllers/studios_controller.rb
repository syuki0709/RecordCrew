class StudiosController < ApplicationController
  skip_before_action :require_login, only: [:index]

  def index
    # スタジオ一覧を取得するロジック
    @studios = Studio.all
  end
end
