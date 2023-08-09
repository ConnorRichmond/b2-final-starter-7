class HolidaysService
  def get_url(url)
    response = Faraday.get(url)
    JSON.parse(response.body)
  end

  def next_three_holidays
    holidays = get_url("https://date.nager.at/api/v3/NextPublicHolidays/US")
    holidays.first(3)
  end
end