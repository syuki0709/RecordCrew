class ReservationsController < ApplicationController
  before_action :set_studio, only: [ :new, :confirm, :finalize ]
  before_action :set_reservation, only: [ :destroy ]

  def new
    @reservation = Reservation.new
  end

  def confirm
    @studio = Studio.find(params[:studio_id])
    date = Date.new(params[:reservation][:year].to_i, params[:reservation][:month].to_i, params[:reservation][:day].to_i)
    start_time = Time.zone.parse("#{date} #{params[:reservation][:start_hour]}")
    end_time = Time.zone.parse("#{date} #{params[:reservation][:end_hour]}")

    @reservation = Reservation.new(
      start_time: start_time,
      end_time: end_time,
      user: current_user,
      studio: @studio,
      status: "pending"
    )
  end

  def finalize
    @studio = Studio.find(params[:studio_id])
    @reservation = current_user.reservations.build(reservation_params)
    @reservation.studio = @studio
    @reservation.status = "確認中"

    if @reservation.save
      Rails.logger.debug "Reservation ID: #{@reservation.id}"
      redirect_to complete_studio_reservation_path(@studio, @reservation), notice: "予約が確定されました。スタジオ側に確認中です。"
    else
      flash[:alert] = "予約確定に失敗しました。"
      redirect_to new_studio_reservation_path(@studio)
    end
  end

  def complete
    Rails.logger.debug "Params: #{params.inspect}"
    @reservation = Reservation.find(params[:id])
    Rails.logger.debug "Reservation: #{@reservation.inspect}"
  end

  def destroy
    if @reservation.user == current_user
      @reservation.destroy
      flash[:notice] = "予約をキャンセルしました。"
    else
      flash[:alert] = "この予約をキャンセルする権限がありません。"
    end
    redirect_to studios_path
  end

  private

  def set_studio
    @studio = Studio.find(params[:studio_id])
  end

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def reservation_params
    # params.require(:reservation).permit(:year, :month, :day, :start_hour, :end_hour)
    params.require(:reservation).permit(:start_time, :end_time, :status)
  end
end
