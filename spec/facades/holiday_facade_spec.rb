require 'rails_helper'

RSpec.describe HolidayFacade do
  describe 'class methods' do
    describe '.upcoming_holidays' do
      it 'returns the upcoming holidays' do
        holidays = HolidayFacade.upcoming_holidays

        expect(holidays).to be_an(Array)
        expect(holidays.length).to eq(3)
        expect(holidays.first.local_name).to be_a(String)
        expect(holidays.first.date).to be_a(String)

        holidays = HolidayFacade.upcoming_holidays(5)

        expect(holidays).to be_an(Array)
        expect(holidays.length).to eq(5)
        expect(holidays.first.local_name).to be_a(String)
        expect(holidays.first.date).to be_a(String)
      end
    end
  end
end
