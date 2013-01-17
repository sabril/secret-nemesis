module ApplicationHelper
  def short_datetime(datetime)
    if datetime
      datetime.strftime("%Y-%m-%d %H:%M:%S")
    else
      ""
    end
  end
end
