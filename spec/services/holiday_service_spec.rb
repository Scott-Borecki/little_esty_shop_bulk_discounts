require 'rails_helper'

RSpec.describe HolidayService do
  describe 'class methods' do
    describe '.holidays' do
      it 'returns holiday data' do
        search = HolidayService.holidays
        expect(search).to be_an(Array)

        holiday = search.first
        expect(holiday).to be_an(Hash)

        expect(holiday).to have_key(:date)
        expect(holiday[:date]).to be_a(String) if holiday[:date].present?

        expect(holiday).to have_key(:localName)
        expect(holiday[:localName]).to be_a(String) if holiday[:localName].present?

        expect(holiday).to have_key(:name)
        expect(holiday[:name]).to be_a(String) if holiday[:name].present?

        expect(holiday).to have_key(:countryCode)
        expect(holiday[:countryCode]).to be_a(String) if holiday[:countryCode].present?

        expect(holiday).to have_key(:fixed)
        expect(holiday[:fixed]).to be_in([true, false]) if holiday[:fixed].present?

        expect(holiday).to have_key(:global)
        expect(holiday[:global]).to be_in([true, false]) if holiday[:global].present?

        expect(holiday).to have_key(:counties)
        expect(holiday[:counties]).to be_an(Array) if holiday[:counties].present?
        expect(holiday[:counties].first).to be_a(String) if holiday[:counties].present?

        expect(holiday).to have_key(:launchYear)
        expect(holiday[:launchYear]).to be_an(Integer) if holiday[:launchYear].present?

        expect(holiday).to have_key(:types)
        expect(holiday[:types]).to be_an(Array) if holiday[:types].present?
        expect(holiday[:types].first).to be_a(String) if holiday[:types].present?
      end
    end
  end
end
