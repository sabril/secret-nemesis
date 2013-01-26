module ApplicationHelper
  
  def title
    if @title
      "#{@title}"
    else
      "Patent Lookup Australia"
    end
  end
  
  def short_datetime(datetime)
    if datetime
      datetime.strftime("%Y-%m-%d %H:%M:%S")
    else
      ""
    end
  end
end
