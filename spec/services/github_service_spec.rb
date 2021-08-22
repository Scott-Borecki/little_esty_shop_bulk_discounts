require 'rails_helper'

RSpec.describe GithubService, type: :service do
  describe 'class methods' do
    describe '.repository' do
      it 'returns the repository data' do
        repository = GithubService.repository
        expect(repository).to be_an(Hash)

        expect(repository).to have_key(:name)
        expect(repository[:name]).to be_a(String) if repository[:name].present?

        expect(repository).to have_key(:html_url)
        if repository[:html_url].present?
          expect(repository[:html_url]).to be_a(String)
        end

        expect(repository).to have_key(:owner)
        if repository[:owner].present?
          expect(repository[:owner]).to be_a(Hash)

          expect(repository[:owner]).to have_key(:login)
          expect(repository[:owner][:login]).to be_a(String)

          expect(repository[:owner]).to have_key(:id)
          expect(repository[:owner][:id]).to be_an(Integer)

          expect(repository[:owner]).to have_key(:html_url)
          expect(repository[:owner][:html_url]).to be_an(String)
        end
      end
    end

    describe '.commits' do
      it 'returns the commits data' do
        commits = GithubService.commits
        expect(commits).to be_an(Array)
        expect(commits.first).to be_an(Hash)

        expect(commits.first).to have_key(:total)
        if commits.first[:total].present?
          expect(commits.first[:total]).to be_an(Integer)
        end

        expect(commits.first).to have_key(:author)
        if commits.first[:author].present?
          expect(commits.first[:author]).to be_a(Hash)
          expect(commits.first[:author]).to have_key(:id)
          expect(commits.first[:author][:id]).to be_an(Integer)
        end
      end
    end

    describe '.pull_requests' do
      it 'returns holiday data' do
        pull_requests = GithubService.pull_requests
        expect(pull_requests).to be_an(Array)
        expect(pull_requests.first).to be_an(Hash)

        expect(pull_requests.first).to have_key(:user)
        if pull_requests.first[:user].present?
          expect(pull_requests.first[:user]).to be_a(Hash)
          expect(pull_requests.first[:user]).to have_key(:id)
          expect(pull_requests.first[:user][:id]).to be_an(Integer)
        end

        expect(pull_requests.first).to have_key(:id)
        if pull_requests.first[:id].present?
          expect(pull_requests.first[:id]).to be_an(Integer)
        end
      end
    end
  end
end
