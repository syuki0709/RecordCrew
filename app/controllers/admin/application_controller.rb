class DashboardController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_studio, only: [ :index, :approve, :cancel ]
  before_action :set_reservation, only: [ :approve, :cancel ]

  private

  def authenticate_admin!
    # 管理者がログインしているかを確認
    unless session[:admin_id] && AdminUser.find_by(id: session[:admin_id])
      # 管理者がログインしていない場合は、管理者ログインページにリダイレクト
      redirect_to admin_studio_login_path, alert: "管理者ログインが必要です"
    end
  end

  def redirect_if_user_logged_in
    if session[:user_id].present? && !session[:admin_id]  # ユーザーがログインしている場合で、かつ管理者ログインしていない場合
      redirect_to root_path, alert: "ユーザーはアクセスできません。"  # ユーザー用のトップページにリダイレクト
    end
  end
end
