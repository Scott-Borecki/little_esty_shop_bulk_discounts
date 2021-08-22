require 'rails_helper'

RSpec.describe HolidayService, type: :service do
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
        if holiday[:localName].present?
          expect(holiday[:localName]).to be_a(String)
        end

        expect(holiday).to have_key(:name)
        expect(holiday[:name]).to be_a(String) if holiday[:name].present?

        expect(holiday).to have_key(:countryCode)
        if holiday[:countryCode].present?
          expect(holiday[:countryCode]).to be_a(String)
        end

        expect(holiday).to have_key(:fixed)
        if holiday[:fixed].present?
          expect(holiday[:fixed]).to be_in([true, false])
        end

        expect(holiday).to have_key(:global)
        if holiday[:global].present?
          expect(holiday[:global]).to be_in([true, false])
        end

        expect(holiday).to have_key(:counties)
        if holiday[:counties].present?
          expect(holiday[:counties]).to be_an(Array)
          expect(holiday[:counties].first).to be_a(String)
        end

        expect(holiday).to have_key(:launchYear)
        if holiday[:launchYear].present?
          expect(holiday[:launchYear]).to be_an(Integer)
        end

        expect(holiday).to have_key(:types)
        if holiday[:types].present?
          expect(holiday[:types]).to be_an(Array)
          expect(holiday[:types].first).to be_a(String)
        end
      end
    end
  end
end
