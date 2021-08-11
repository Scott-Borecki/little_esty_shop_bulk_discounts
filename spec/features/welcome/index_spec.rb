require 'rails_helper'

RSpec.describe 'welcome index (/)' do
  create_factories

  describe 'as a user' do
    describe 'when I visit my welcome index (/m)' do
      before { visit root_path }

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
    end
  end
end
