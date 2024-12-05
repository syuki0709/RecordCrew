module ApplicationHelper
  def status_label_class(status)
    case status
    when "pending"
      "label-default"
    when "under_review"
      "label-warning"
    when "confirmed"
      "label-success"
    when "declined"
      "label-danger"
    else
      "label-default"
    end
  end
end
