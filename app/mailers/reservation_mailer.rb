class ReservationMailer < ApplicationMailer
  def notify_studio(reservation)
    @reservation = reservation
    @studio = reservation.studio
    mail(to: @studio.email, subject: "新しい予約が確定しました")
  end

  def notify_user(reservation, action)
    @reservation = reservation
    @action = action # "承認" or "キャンセル"
    mail(to: @reservation.user.email, subject: "予約が#{@action}されました")
  end
end
