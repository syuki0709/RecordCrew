class Admin::DashboardController < ApplicationController
  before_action :set_studio, only: [:index, :approve, :cancel]
  before_action :set_reservation, only: [:approve, :cancel]

  def index
    @new_reservations = @studio.reservations.where(status: 'under_review')
    
    # 営業日ごとの営業時間データを取得
    @availabilities = @studio.studio_availabilities
                              .where(date: Date.today..1.month.from_now)
                              .order(:date)
  
    # 予約情報を取得
    @reservations = @studio.reservations
                            .where(start_time: Date.today.beginning_of_day..(Date.today + 1.month).end_of_day)
                            .distinct
                            .order(:start_time)
  
    # 営業時間スロットを準備
    @availability_slots = @availabilities.map do |availability|
      start_hour = availability.business_hour_start.hour
      end_hour = availability.business_hour_end.hour
  
      # 承認された予約をカウント
      approved_reservations = @studio.reservations
                                     .where(studio_id: @studio.id, status: 'confirmed',
                                            start_time: availability.date.beginning_of_day..availability.date.end_of_day)
                                     .count
  
      time_slots = (start_hour...end_hour).map do |hour|
        reserved = @reservations.any? do |reservation|
          reservation_date = reservation.start_time.to_date
          reservation_start_hour = reservation.start_time.hour
          reservation_end_hour = reservation.end_time.hour
  
          # 予約時間がこの時間帯を含む場合
          reservation_date == availability.date &&
            (reservation_start_hour <= hour && reservation_end_hour > hour)
        end
  
        # 時間帯の状態を設定
        { hour: hour, available: !reserved }
      end
  
      { availability: availability, time_slots: time_slots, approved_reservations: approved_reservations }
    end
  end
  
  def approve
    @reservation.update(status: "confirmed")
    ReservationMailer.notify_user(@reservation, "承認").deliver_later
    redirect_to admin_dashboard_path(@studio), notice: "予約を承認しました。"
  end

  def cancel
    @reservation.update(status: "declined")
    ReservationMailer.notify_user(@reservation, "キャンセル").deliver_later
    redirect_to admin_dashboard_path(@studio), alert: "予約がキャンセルされました。"
  end

  private

  def set_studio
    @studio = Studio.find(params[:studio_id])
  end

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end
end