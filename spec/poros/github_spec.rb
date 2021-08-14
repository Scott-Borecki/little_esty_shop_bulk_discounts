require 'rails_helper'

RSpec.describe Github do
  it 'exists' do
    attrs = {
      name: 'little_esty_shop_bulk_discounts',
      html_url: 'https://github.com/Scott-Borecki/little_esty_shop_bulk_discounts',
      owner: {
        id: 79381792,
        login: 'Scott-Borecki',
        html_url: 'https://github.com/Scott-Borecki'
      }
    }

    github = Github.new(attrs)

    expect(github).to be_a(Github)
    expect(github.repo_name).to eq('little_esty_shop_bulk_discounts')
    expect(github.url).to eq('https://github.com/Scott-Borecki/little_esty_shop_bulk_discounts')
    expect(github.owner).to eq('Scott-Borecki')
    expect(github.owner_id).to eq(79381792)
    expect(github.owner_url).to eq('https://github.com/Scott-Borecki')
  end
end
