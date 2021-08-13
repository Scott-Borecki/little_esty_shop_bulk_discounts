require './spec/support/factory_bot'

def create_objects_top_revenue_day
  let!(:merchant1) { create(:merchant) }
  let!(:merchant2) { create(:merchant) }

  let!(:item1) { create(:item, merchant: merchant1, status: 1) }
  let!(:item2) { create(:item, merchant: merchant1) }
  let!(:item3) { create(:item, merchant: merchant1) }
  let!(:item4) { create(:item, merchant: merchant1) }
  let!(:item7) { create(:item, merchant: merchant1) }
  let!(:item8) { create(:item, merchant: merchant1) }

  let!(:item5) { create(:item, merchant: merchant2) }
  let!(:item6) { create(:item, merchant: merchant2) }

  let!(:invoice1) { create(:invoice, status: 2, created_at: "2012-03-27 14:54:09") }
  let!(:invoice2) { create(:invoice, status: 2, created_at: "2012-03-28 14:54:09") }
  let!(:invoice3) { create(:invoice, status: 2) }
  let!(:invoice4) { create(:invoice, status: 2) }
  let!(:invoice5) { create(:invoice, status: 2) }
  let!(:invoice6) { create(:invoice, status: 2) }
  let!(:invoice7) { create(:invoice, status: 1) }

  let!(:ii1) { create(:invoice_item, invoice: invoice1, item: item1, quantity: 9, unit_price: 10099, status: 2, created_at: "2012-03-27 14:54:09") }
  let!(:ii2) { create(:invoice_item, invoice: invoice2, item: item1, quantity: 9, unit_price: 10099, status: 2, created_at: "2012-03-28 14:54:09") }
  let!(:ii3) { create(:invoice_item, invoice: invoice3, item: item2, quantity: 2, unit_price: 8099,  status: 2) }
  let!(:ii4) { create(:invoice_item, invoice: invoice4, item: item3, quantity: 3, unit_price: 5099,  status: 1) }
  let!(:ii6) { create(:invoice_item, invoice: invoice5, item: item4, quantity: 1, unit_price: 1099,  status: 1) }
  let!(:ii7) { create(:invoice_item, invoice: invoice6, item: item7, quantity: 1, unit_price: 3099,  status: 1) }
  let!(:ii8) { create(:invoice_item, invoice: invoice7, item: item8, quantity: 1, unit_price: 5099,  status: 1) }
  let!(:ii9) { create(:invoice_item, invoice: invoice7, item: item4, quantity: 1, unit_price: 1099,  status: 1) }

  let!(:transaction1) { create(:transaction, result: 1, invoice: invoice1) }
  let!(:transaction2) { create(:transaction, result: 1, invoice: invoice2) }
  let!(:transaction3) { create(:transaction, result: 1, invoice: invoice3) }
  let!(:transaction4) { create(:transaction, result: 1, invoice: invoice4) }
  let!(:transaction5) { create(:transaction, result: 1, invoice: invoice5) }
  let!(:transaction6) { create(:transaction, result: 0, invoice: invoice6) }
  let!(:transaction7) { create(:transaction, result: 1, invoice: invoice7) }
end
