class ApplicationController < ActionController::Base
  before_action :require_login, except: [:admin_login]

  private

  def require_login
    if !logged_in?
      not_authenticated
    end
  end

  def not_authenticated
    redirect_to login_path
  end

  def admin_login
    redirect_to admin_studio_login_path
  end
end