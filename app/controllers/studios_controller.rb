class StudiosController < ApplicationController
  skip_before_action :require_login, only: [:index]

  def index
    # @studios = Studio.all
  end
end
