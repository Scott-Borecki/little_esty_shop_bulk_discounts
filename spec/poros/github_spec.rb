require 'rails_helper'

RSpec.describe Github do
  it 'exists' do
    attrs = {
      name: 'little_esty_shop_bulk_discounts'
    }

    github = Github.new(attrs)

    expect(github).to be_a(Github)
    expect(github.repo_name).to eq('little_esty_shop_bulk_discounts')
  end
end
