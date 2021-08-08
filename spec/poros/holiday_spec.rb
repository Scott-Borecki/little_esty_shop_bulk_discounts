require 'rails_helper'

RSpec.describe Holiday do
  it 'exists' do
    attrs = {
      date: '2021-09-06',
      localName: 'Labor Day',
      name: 'Labour Day',
      countryCode: 'US',
      fixed: false,
      global: true,
      counties: nil,
      launchYear: nil,
      types: ['Public']
    }

    holiday = Holiday.new(attrs)

    expect(holiday).to be_a(Holiday)
    expect(holiday.date).to eq('2021-09-06')
    expect(holiday.local_name).to eq('Labor Day')
    expect(holiday.name).to eq('Labour Day')
    expect(holiday.country_code).to eq('US')
    expect(holiday.fixed).to eq(false)
    expect(holiday.global).to eq(true)
    expect(holiday.counties).to eq(nil)
    expect(holiday.launch_year).to eq(nil)
    expect(holiday.types).to eq(['Public'])
  end
end
