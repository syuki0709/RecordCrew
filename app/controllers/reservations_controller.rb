class ReservationsController < ApplicationController
  before_action :set_studio, only: [ :new, :confirm, :finalize ]
  before_action :set_reservation, only: [ :destroy ]

  def new
    @reservation = Reservation.new
  end

  def confirm
    @studio = Studio.find(params[:studio_id])
    date = Date.new(
      params[:reservation][:year].to_i,
      params[:reservation][:month].to_i,
      params[:reservation][:day].to_i
    )
    start_time = Time.zone.parse("#{date} #{params[:reservation][:start_hour]}")
    end_time = Time.zone.parse("#{date} #{params[:reservation][:end_hour]}")

    @reservation = Reservation.new(
      start_time: start_time,
      end_time: end_time,
      user: current_user,
      studio: @studio,
      status: :pending
    )
  end

  def finalize
    @studio = Studio.find(params[:studio_id])
    @reservation = current_user.reservations.build(reservation_params)
    @reservation.studio = @studio
    @reservation.status = :under_review

    if @reservation.save
      ReservationMailer.notify_studio(@reservation).deliver_now
      redirect_to complete_studio_reservation_path(@studio, @reservation),
                  notice: "予約しました。スタジオ側に確認中です。"
    else
      flash[:alert] = "予約に失敗しました。"
      redirect_to new_studio_reservation_path(@studio)
    end
  end

  def approve
    @reservation = Reservation.find(params[:id])
    @reservation.update!(status: :confirmed)
    ReservationMailer.notify_user(@reservation).deliver_later
    redirect_to admin_dashboard_path, notice: "予約を承認しました。"
  end

  def decline
    @reservation = Reservation.find(params[:id])
    @reservation.update!(status: :declined)
    ReservationMailer.notify_user(@reservation).deliver_later
    redirect_to admin_dashboard_path, notice: "予約をキャンセルしました。"
  end

  def complete
    @reservation = Reservation.find(params[:id])
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
    params.require(:reservation).permit(:start_time, :end_time, :status)
  end
end
