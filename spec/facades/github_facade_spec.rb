require 'rails_helper'

RSpec.describe GithubFacade, type: :facade do
  describe 'class methods' do
    describe '.repository' do
      it 'returns the repository as a Github object' do
        repository = GithubFacade.repository

        expect(repository).to be_a(Github)
        expect(repository.repo_name).to eq('little_esty_shop_bulk_discounts')
        expect(repository.url).to eq('https://github.com/Scott-Borecki/little_esty_shop_bulk_discounts')
        expect(repository.owner).to eq('Scott-Borecki')
        expect(repository.owner_id).to eq(79381792)
        expect(repository.owner_url).to eq('https://github.com/Scott-Borecki')
      end
    end
      end
    end
  end
end
