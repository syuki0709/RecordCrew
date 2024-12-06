class SessionsController < ApplicationController
  skip_before_action :not_authenticated, only: [ :new, :create ]

  def new
  end

  def create
    @user = login(params[:email], params[:password])
    if @user
      redirect_to root_path, notice: "ログインに成功しました。"
    else
      flash.now[:alert] = "ログインに失敗しました。メールアドレスまたはパスワードをご確認ください。"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to root_path, status: :see_other, notice: "ログアウトしました。"
  end
end
