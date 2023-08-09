module ApplicationHelper
  def string_to_date(string)
    Date.parse(string).strftime("%A, %B %d, %Y")
  end
end