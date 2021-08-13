require 'rails_helper'

RSpec.describe GithubFacade do
  describe 'class methods' do
    describe '.repository_name' do
      it 'returns the repository name' do
        allow(GithubService).to receive(:repository).and_return(repo_parsed)

        repository_name = GithubFacade.repository_name

        expect(repository_name).to be_an(String)
        expect(repository_name).to eq('little_esty_shop_bulk_discounts')
      end
    end
  end
end
