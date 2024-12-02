class StudiosController < ApplicationController
  skip_before_action :require_login, only: [ :index, :availability ]
  before_action :set_user_reservations, only: :index
  before_action :set_studio, only: [ :availability ]
  # before_action :authenticate_user!, except: [:index, :availability]

  def index
    # スタジオ一覧を取得するロジック
    @studios = Studio.all
    if logged_in?
      @user_reservations = current_user.reservations.includes(:studio) # ユーザーの予約を取得
    else
      @user_reservations = []
    end
  end

  def availability
    @studio = Studio.find(params[:id])
  
    # 営業日の取得
    @availabilities = @studio.studio_availabilities
                             .where(date: Date.today..1.month.from_now)
                             .order(:date)
  
    # 対応する予約の取得
    @reservations = @studio.reservations
                           .where(start_time: Date.today.beginning_of_day..(Date.today + 1.month).end_of_day)
                           .distinct
                           .order(:start_time)

    @availability_slots = @availabilities.map do |availability|
      start_hour = availability.business_hour_start.hour
      end_hour = availability.business_hour_end.hour
    
      time_slots = (start_hour...end_hour).map do |hour|
        reserved = @reservations.any? do |reservation|
          reservation_date = reservation.start_time.to_date
          reservation_hour = reservation.start_time.hour
          reservation_date == availability.date && reservation_hour == hour
        end
    
        { hour: hour, available: !reserved }
      end
    
      { availability: availability, time_slots: time_slots }
    end
  end

  private

  def calculate_availability_slots(availabilities, reservations)
    availabilities.map do |availability|
      start_hour = availability.business_hour_start.hour
      end_hour = availability.business_hour_end.hour
      time_slots = (start_hour...end_hour).map do |hour|
        reserved = reservations.any? do |reservation|
          reservation.start_time.to_date == availability.date && reservation.start_time.hour == hour
        end
        { hour: hour, available: !reserved }
      end
      { availability: availability, time_slots: time_slots }
    end
  end

  def set_user_reservations
    if logged_in?
      @user_reservations =  @reservations = current_user.reservations.includes(:studio)
    else
      @user_reservations = []
    end
  end

  def set_studio
    @studio = Studio.find(params[:id])
  end
end
