module Admin
  class SchedulesController < ApplicationController
    before_action :set_availability, only: [:toggle]
    before_action :set_reservation, only: [:approve_reservation, :cancel_reservation]

    def toggle
      # studioとavailabilityの取得
      @studio = Studio.find(params[:studio_id])
      availability = StudioAvailability.find(params[:id])
      hour = params[:hour].to_i
      
      # 対象時間帯の予約状態を反転させる
      reserved = @studio.reservations
                        .where(studio_id: @studio.id, status: 'confirmed')
                        .where("start_time BETWEEN ? AND ?", availability.date.beginning_of_day + hour.hours, availability.date.beginning_of_day + (hour + 1).hours)
                        .exists?
  
      new_available_status = !reserved
  
      # 予約可能状態を変更
      availability.update(available_status: new_available_status)
  
      # レスポンスとしてインクリメントされた状態を返す
      respond_to do |format|
        format.js { render json: { available: new_available_status } }
      end
    end

    def approve_reservation
      if @reservation.update!(status: :confirmed)
        ReservationMailer.confirmed(@reservation).deliver_now  # メール送信
        flash[:notice] = "予約が承認されました。"
        redirect_to admin_studio_dashboard_index_path(studio_id: @studio.id)
      else
        flash[:alert] = "予約承認に失敗しました。"
        redirect_to admin_studio_dashboard_index_path(studio_id: @studio.id)
      end
    end

    def cancel_reservation
      if @reservation.update!(status: :declined)
        ReservationMailer.canceled(@reservation).deliver_now  # メール送信
        @reservation.destroy  # 予約情報を削除
    
        @studio_availabilities = @reservation.studio.studio_availabilities.where(date: @reservation.start_time.to_date)
        @studio_availabilities.each do |availability|
          availability.update!(available_status: true) unless @reservation.status == 'canceled'
        end
    
        flash[:notice] = "予約がキャンセルされました。"
        redirect_to admin_studio_dashboard_index_path(studio_id: @studio.id)
      else
        flash[:alert] = "予約キャンセルに失敗しました。"
        redirect_to admin_studio_dashboard_index_path(studio_id: @studio.id)
      end
    end

    private

    def set_availability
      @studio = Studio.find(params[:studio_id])
      @availability = StudioAvailability.find_by(studio: @studio, day_of_week: params[:day_of_week])
    end

    def set_reservation
      @reservation = Reservation.find(params[:id])
      @studio = @reservation.studio
    end

    def generate_availability_slots(availability)
      start_hour = availability.business_hour_start.hour
      end_hour = availability.business_hour_end.hour

      # 対応する予約を取得
      @reservations = @studio.reservations
                            .where(start_time: Date.today.beginning_of_day..(Date.today + 1.month).end_of_day)
                            .distinct
                            .order(:start_time)

      time_slots = (start_hour...end_hour).map do |hour|
        reserved = @reservations.any? do |reservation|
          reservation_date = reservation.start_time.to_date
          reservation_hour = reservation.start_time.hour
          reservation_date == availability.date && reservation_hour == hour
        end

        { hour: hour, available: !reserved }
      end

      [{ availability: availability, time_slots: time_slots }]
    end
  end
end
