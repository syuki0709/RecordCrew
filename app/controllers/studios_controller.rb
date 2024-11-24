class StudiosController < ApplicationController
  skip_before_action :require_login, only: [ :index ]
  before_action :set_user_reservations, only: :index

  def index
    # スタジオ一覧を取得するロジック
    @studios = Studio.all
  end

  private

  def set_user_reservations
    if logged_in?
      @user_reservations =  @reservations = current_user.reservations.includes(:studio)
    else
      @user_reservations = []
    end
  end
end
