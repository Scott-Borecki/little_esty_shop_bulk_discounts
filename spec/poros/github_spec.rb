require 'rails_helper'

RSpec.describe Github, type: :poro do
  let!(:github) do
    Github.new(
      name: 'little_esty_shop_bulk_discounts',
      html_url: 'https://github.com/Scott-Borecki/little_esty_shop_bulk_discounts',
      owner: {
        id: 79381792,
        login: 'Scott-Borecki',
        html_url: 'https://github.com/Scott-Borecki'
      }
    )
  end

  it 'exists' do
    expect(github).to be_a(Github)
    expect(github.repo_name).to eq('little_esty_shop_bulk_discounts')
    expect(github.url).to eq('https://github.com/Scott-Borecki/little_esty_shop_bulk_discounts')
    expect(github.owner).to eq('Scott-Borecki')
    expect(github.owner_id).to eq(79381792)
    expect(github.owner_url).to eq('https://github.com/Scott-Borecki')
  end

  describe 'instance methods' do
    describe '#number_of_commits' do
      it 'returns the number of owner commits' do
        expect(github.number_of_commits).to be_an(Integer)
      end
    end

    describe '#number_of_pull_requests' do
      it 'returns the number of owner pull requests' do
        expect(github.number_of_pull_requests).to be_an(Integer)
      end
    end
  end
end
