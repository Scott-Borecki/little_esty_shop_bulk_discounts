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

    describe '.number_of_commits' do
      it 'returns the number of commits' do
        user_id = 79381792
        commits = GithubFacade.number_of_commits(user_id)

        expect(commits).to be_an(Integer)
      end
    end

    describe '.number_of_pull_requests' do
      it 'returns the number of pull requests' do
        user_id = 79381792
        number_of_pull_requests = GithubFacade.number_of_pull_requests(user_id)

        expect(number_of_pull_requests).to be_an(Integer)
      end
    end
  end
end
