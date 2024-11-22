class ReservationsController < ApplicationController
  def create
    @reservation = current_user.reservations.build(reservation_params)
    @reservation.studio = Studio.find(params(:studio_id))

    if @reservation.save
      redirect_to studio_path(@reservation.studio), notice: "予約が作成されました"
    else
      redirect_to studio_path(@reservation.studio), alert: "予約の作成に失敗しました"
    end

    private

    def reservation_params
      params.require(:reservation).permit(:start_time, :end_time, :status)
    end
end
