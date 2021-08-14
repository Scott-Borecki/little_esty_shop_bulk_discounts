class HolidayFacade
  def self.upcoming_holidays(quantity = 3)
    holidays = HolidayService.holidays
    holidays[0..(quantity - 1)].map do |holiday_data|
      Holiday.new(holiday_data)
    end
  end
end
