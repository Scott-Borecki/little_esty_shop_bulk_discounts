require './spec/support/factory_bot'

def create_objects_merchant_dashboard
  let!(:merchant1) { create(:merchant) }
  let!(:merchant2) { create(:merchant) }

  let!(:customer1) { create(:customer) }
  let!(:customer2) { create(:customer) }
  let!(:customer3) { create(:customer) }
  let!(:customer4) { create(:customer) }
  let!(:customer5) { create(:customer) }
  let!(:customer6) { create(:customer) }

  let!(:invoice1) { create(:invoice, customer: customer1, status: 2) }
  let!(:invoice2) { create(:invoice, customer: customer1, status: 2) }
  let!(:invoice3) { create(:invoice, customer: customer2, status: 2) }
  let!(:invoice4) { create(:invoice, customer: customer3, status: 2) }
  let!(:invoice5) { create(:invoice, customer: customer4, status: 2) }
  let!(:invoice6) { create(:invoice, customer: customer5, status: 2) }
  let!(:invoice7) { create(:invoice, customer: customer6, status: 1) }

  let!(:item1) { create(:item, unit_price: 10_099, merchant: merchant1) }
  let!(:item2) { create(:item, unit_price: 8_099,  merchant: merchant1) }
  let!(:item3) { create(:item, unit_price: 5_099,  merchant: merchant1) }
  let!(:item4) { create(:item, unit_price: 1_099,  merchant: merchant1) }

  let!(:ii_1) { create(:invoice_item, invoice: invoice1, item: item1, quantity: 1, unit_price: 100_99, status: 0) }
  let!(:ii_2) { create(:invoice_item, invoice: invoice1, item: item2, quantity: 1, unit_price: 80_99,  status: 0) }
  let!(:ii_3) { create(:invoice_item, invoice: invoice2, item: item3, quantity: 1, unit_price: 50_99,  status: 2) }
  let!(:ii_4) { create(:invoice_item, invoice: invoice3, item: item4, quantity: 1, unit_price: 50_99,  status: 1) }

  let!(:transaction1) { create(:transaction, result: 1, invoice: invoice1) }
  let!(:transaction2) { create(:transaction, result: 1, invoice: invoice3) }
  let!(:transaction3) { create(:transaction, result: 1, invoice: invoice4) }
  let!(:transaction4) { create(:transaction, result: 1, invoice: invoice5) }
  let!(:transaction5) { create(:transaction, result: 1, invoice: invoice6) }
  let!(:transaction6) { create(:transaction, result: 1, invoice: invoice7) }
  let!(:transaction7) { create(:transaction, result: 1, invoice: invoice2) }

  let!(:bulk_discount1_1) { create(:bulk_discount, merchant: merchant1, percentage_discount: 20, quantity_threshold: 10) }
  let!(:bulk_discount1_2) { create(:bulk_discount, merchant: merchant1, percentage_discount: 15, quantity_threshold: 15) }
  let!(:bulk_discount1_3) { create(:bulk_discount, merchant: merchant1, percentage_discount: 30, quantity_threshold: 20) }
  let!(:bulk_discount2_1) { create(:bulk_discount, merchant: merchant2, percentage_discount: 12, quantity_threshold: 12) }
  let!(:bulk_discount2_2) { create(:bulk_discount, merchant: merchant2, percentage_discount: 14, quantity_threshold: 17) }
  let!(:bulk_discount2_3) { create(:bulk_discount, merchant: merchant2, percentage_discount: 22, quantity_threshold: 21) }
end
