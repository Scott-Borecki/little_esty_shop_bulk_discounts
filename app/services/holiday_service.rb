class HolidayService
  def self.holidays(country_code = 'US')
    response = Faraday.get("https://date.nager.at/api/v3/NextPublicHolidays/#{country_code}")
    JSON.parse(response.body, symbolize_names: true)
  end
end
