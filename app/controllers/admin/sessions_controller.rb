class Admin::SessionsController < ApplicationController
  # skip_before_action :authenticate_admin!, only: [:new, :create]

  def new
    # ログイン画面表示
    @studio = Studio.find_by(id: params[:studio_id])  # スタジオIDを取得
  end

  def create
    # 管理者ユーザーをログイン
    @admin_user = AdminUser.find_by(email: params[:email])
    
    # 管理者ユーザーが見つからなければエラーメッセージ
    if @admin_user.nil? || !@admin_user.authenticate(params[:password])
      flash.now[:alert] = "メールアドレスまたはパスワードが間違っています"
      render :new, status: :unprocessable_entity and return
    end
    
    # スタジオをメールアドレスから検索
    @studio = Studio.find_by(email: params[:email])
    
    if @studio.nil?
      flash.now[:alert] = "そのメールアドレスに対応するスタジオが見つかりません"
      render :new, status: :unprocessable_entity and return
    end
    
    # 管理者が所属するスタジオをチェック
    if @admin_user.studio != @studio
      flash.now[:alert] = "このメールアドレスはそのスタジオには関連付けられていません"
      render :new, status: :unprocessable_entity and return
    end
    
    # ログイン成功時、セッションに管理者のIDをセット
    session[:admin_id] = @admin_user.id
    
    # ダッシュボードへ遷移
    redirect_to admin_studio_dashboard_index_path(@studio), notice: "#{@studio.name}のダッシュボードにログインしました"
  end

  def destroy
    session[:admin_id] = nil
    redirect_to admin_studios_path, notice: "ログアウトしました"
  end
end
