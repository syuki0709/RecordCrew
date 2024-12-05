class ReservationMailer < ApplicationMailer
  def notify_studio(reservation)
    @reservation = reservation
    @studio = reservation.studio
    mail(to: @studio.email, subject: "新しい予約が入りました")
  end

  def notify_user(reservation, action)
    @reservation = reservation
    @action = action # "承認" or "キャンセル"
    mail(to: @reservation.user.email, subject: "予約が#{@action}されました")
  end

  def confirmed(reservation)
    @reservation = reservation
    @user = @reservation.user
    @studio = @reservation.studio
    @start_time = @reservation.start_time.strftime("%Y年%m月%d日 %H:%M")
    @end_time = @reservation.end_time.strftime("%H:%M")

    mail(to: @reservation.user.email, subject: "予約が承諾されました - #{@studio.name}")
  end

  def canceled(reservation)
    @reservation = reservation
    @user = @reservation.user
    @studio = @reservation.studio
    @start_time = @reservation.start_time.strftime("%Y年%m月%d日 %H:%M")
    @end_time = @reservation.end_time.strftime("%H:%M")

    mail(to: @reservation.user.email, subject: "予約がキャンセルされました - #{@studio.name}")
  end
end
