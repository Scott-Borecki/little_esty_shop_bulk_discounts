class HolidayService
  def self.holidays(country_code = 'US')
    url      = "https://date.nager.at/api/v3/NextPublicHolidays/#{country_code}"
    response = Faraday.get(url)

    JSON.parse(response.body, symbolize_names: true)
  end
end
