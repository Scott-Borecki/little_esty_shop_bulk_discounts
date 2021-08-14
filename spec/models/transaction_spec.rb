require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe "validations" do
    it { should define_enum_for(:result).with_values(failed: 0, success: 1) }
    it { should validate_presence_of(:credit_card_number) }
    it { should validate_numericality_of(:credit_card_number) }
    it { should validate_length_of(:credit_card_number).is_at_least(15).is_at_most(16) }
    it { should validate_presence_of(:credit_card_expiration_date) }
    it { should validate_numericality_of(:credit_card_expiration_date) }
    it { should validate_length_of(:credit_card_expiration_date).is_equal_to(4) }
    it { should validate_presence_of(:result) }

    it 'is valid with valid attributes' do
      transaction = create(:transaction)
      expect(transaction).to be_valid
    end
  end

  describe "relationships" do
    it { should belong_to(:invoice) }
  end

  describe 'scopes' do
    describe '.successful' do
      it 'includes transactions that are successful' do
        transaction = create(:transaction, result: 1)
        expect(Transaction.successful).to include(transaction)
      end

      it 'excludes transactions that are not successful' do
        transaction = create(:transaction, result: 0)
        expect(Transaction.successful).to_not include(transaction)
      end
    end
  end
end
