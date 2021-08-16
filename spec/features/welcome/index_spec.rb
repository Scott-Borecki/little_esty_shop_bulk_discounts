require 'rails_helper'

RSpec.describe 'welcome index (/)' do
  let!(:merchant) { create(:merchant) }
  let!(:bulk_discount) { create(:bulk_discount, merchant: merchant) }
  let!(:item) { create(:item, merchant: merchant) }
  let!(:invoice) { create(:invoice) }
  let!(:transaction) { create(:transaction, result: 1, invoice: invoice) }
  let!(:invoice_item) { create(:invoice_item, invoice: invoice, item: item) }

  describe 'as a user' do
    describe 'when I visit my welcome index (/)' do
      before { visit root_path }
      let(:repository) { GithubFacade.repository }

      it 'displays the welcome page' do
        expect(current_path).to eq(root_path)
      end

      it 'links to the home page' do
        expect(page).to have_link('Little Esty Shop')

        click_link('Little Esty Shop')

        expect(current_path).to eq(root_path)
      end

      it 'links to the admin dashboard' do
        expect(page).to have_link('Admin Dashboard')

        click_link('Admin Dashboard')

        expect(current_path).to eq(admin_dashboard_index_path)
      end

      it 'links to the merchant dashboard' do
        expect(page).to have_link('Merchant Dashboard')

        click_link('Merchant Dashboard')

        expect(current_path).to include('/merchant/')
        expect(current_path).to include('/dashboard')
      end

      it 'displays the GitHub repository name' do
        expect(page).to have_content("GitHub Repository: #{repository.repo_name}")
        expect(page).to have_link(repository.repo_name)
        # FIX: Add a driver so external URLs can be visited in tests
        #
        # click_link repository.repo_name
        #
        # expect(current_url).to eq('https://github.com/Scott-Borecki/little_esty_shop_bulk_discounts')
      end

      it 'displays the GitHub repository owner name' do
        expect(page).to have_content("Repository Owner: #{repository.owner}")
        expect(page).to have_link(repository.owner)
        # FIX: Add a driver so external URLs can be visited in tests
        #
        # click_link repository.owner
        #
        # expect(current_url).to eq('https://github.com/Scott-Borecki')
      end

      it 'displays the number of commits by the owner' do
        expect(page).to have_content("Number of Commits: #{repository.number_of_commits}")
      end

      it 'displays the number of pull requests by the owner' do
        expect(page).to have_content("Number of Pull Requests: #{repository.number_of_pull_requests}")
      end
    end
  end
end
