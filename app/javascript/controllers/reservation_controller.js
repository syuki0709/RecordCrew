document.addEventListener("turbo:load", function() {
  const hourlyRate = document.getElementById("studio-hourly-rate").value;
  const startHourSelect = document.getElementById("reservation_start_hour");
  const endHourSelect = document.getElementById("reservation_end_hour");
  const totalPriceElement = document.getElementById("total-price");

  function calculateTotalPrice() {
    const startHour = parseInt(startHourSelect.value, 10);
    const endHour = parseInt(endHourSelect.value, 10);

    // 開始時間と終了時間が逆の場合、0円に設定
    if (isNaN(startHour) || isNaN(endHour) || endHour <= startHour) {
      totalPriceElement.textContent = "0";
      return;
    }

    const duration = endHour - startHour;
    const totalPrice = duration * hourlyRate;
    totalPriceElement.textContent = totalPrice;
  }

  startHourSelect.addEventListener("change", calculateTotalPrice);
  endHourSelect.addEventListener("change", calculateTotalPrice);

  // 初期状態で計算
  calculateTotalPrice();
});