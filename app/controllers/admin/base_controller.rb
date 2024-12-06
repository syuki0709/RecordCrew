class Admin::BaseController < ApplicationController

  private

  def current_admin
    # セッションやトークンなどで管理者が認証されているか確認
    @current_admin ||= Admin.find(session[:admin_id]) if session[:admin_id]
  end
end