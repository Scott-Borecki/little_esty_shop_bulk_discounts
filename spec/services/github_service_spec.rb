require 'rails_helper'

RSpec.describe GithubService, type: :service do
  describe 'class methods' do
    describe '.repository' do
      it 'returns holiday data' do
        repository = GithubService.repository
        expect(repository).to be_an(Hash)

        expect(repository).to have_key(:name)
        expect(repository[:name]).to be_a(String) if repository[:name].present?

        expect(repository).to have_key(:html_url)
        expect(repository[:html_url]).to be_a(String) if repository[:html_url].present?

        expect(repository).to have_key(:owner)
        if repository[:owner].present?
          expect(repository[:owner][:login]).to be_a(String)
          expect(repository[:owner][:id]).to be_an(Integer)
          expect(repository[:owner][:html_url]).to be_an(String)
        end
      end
    end

    describe '.commits' do
      it 'returns holiday data' do
        commits = GithubService.commits
        expect(commits).to be_an(Array)
        expect(commits.first).to be_an(Hash)

        expect(commits.first).to have_key(:total)
        expect(commits.first[:total]).to be_an(Integer) if commits.first[:total].present?

        expect(commits.first).to have_key(:author)
        if commits.first[:author].present?
          expect(commits.first[:author]).to be_a(Hash)
          expect(commits.first[:author][:id]).to be_an(Integer)
        end
      end
    end
      end
    end
  end
end
