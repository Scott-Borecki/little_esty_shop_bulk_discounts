require 'rails_helper'

RSpec.describe GithubService, type: :service do
  describe 'class methods' do
    describe '.repository' do
      it 'returns holiday data' do
        repository = GithubService.repository
        expect(repository).to be_an(Hash)

        expect(repository).to have_key(:name)
        expect(repository[:name]).to be_a(String) if repository[:name].present?
      end
    end
  end
end
