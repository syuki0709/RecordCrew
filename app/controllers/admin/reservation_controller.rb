class Admin::ReservationsController < ApplicationController
  def accept
    reservation = Reservation.find(params[:id])
    reservation.update!(status: "confirmed")

    # 予約の時間帯がグレーに変更される処理
    availability = StudioAvailability.find_by(date: @reservation.start_time.to_date)
    availability.update!(available_status: false)

    # ユーザーに通知メールを送信
    ReservationMailer.confirmed(reservation).deliver_now
    flash[:notice] = "予約が承諾されました。"
    redirect_to admin_dashboard_path
  end

  def decline
    reservation = Reservation.find(params[:id])
    reservation.update!(status: "declined")

    # 予約情報を削除
    @reservation.destroy

    # ユーザーに通知メールを送信
    ReservationMailer.canceled(reservation).deliver_now

    flash[:notice] = "予約がキャンセルされました。"
    redirect_to admin_dashboard_path
  end
end
