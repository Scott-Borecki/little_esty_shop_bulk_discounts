require './spec/support/factory_bot'

def create_objects_merchant_with_many_customers_and_items
  let!(:customer1) {  create(:customer) } # Transaction_count = 1
  let!(:customer2) {  create(:customer) } # Transaction_count = 3 #=> Top Customer 3
  let!(:customer3) {  create(:customer) } # Transaction_count = 5 #=> Top Customer 1
  let!(:customer4) {  create(:customer) } # Transaction_count = 4 #=> Top Customer 2
  let!(:customer5) {  create(:customer) } # Transaction_count = 1
  let!(:customer6) {  create(:customer) } # Transaction_count = 1
  let!(:customer7) {  create(:customer) } # Transaction_count = 2 #=> Top Customer 4 (4a)
  let!(:customer8) {  create(:customer) } # Transaction_count = 2 #=> Top Customer 5 (4b)
  let!(:customer9) {  create(:customer) } # Transaction_count = 1
  let!(:customer10) { create(:customer) } # Transaction_count = 1

  let!(:merchant) { create(:enabled_merchant) }
                                                      # total_revenue only considers successful transaction
  let!(:item1) {  create(:item, merchant: merchant) } # total_revenue = 100
  let!(:item2) {  create(:item, merchant: merchant) } # total_revenue = 140
  let!(:item3) {  create(:item, merchant: merchant) } # total_revenue = 110
  let!(:item4) {  create(:item, merchant: merchant) } # total_revenue = 130
  let!(:item5) {  create(:item, merchant: merchant) } # total_revenue = 250 #=> Top Item 1
  let!(:item6) {  create(:item, merchant: merchant) } # total_revenue = 160
  let!(:item7) {  create(:item, merchant: merchant) } # total_revenue = 120
  let!(:item8) {  create(:item, merchant: merchant) } # total_revenue = 210 #=> Top Item 3
  let!(:item9) {  create(:item, merchant: merchant) } # total_revenue = 110
  let!(:item10) { create(:item, merchant: merchant) } # total_revenue = 130
  let!(:item11) { create(:item, merchant: merchant) } # total_revenue = 150
  let!(:item12) { create(:item, merchant: merchant) } # total_revenue = 200 #=> Top Item 4
  let!(:item13) { create(:item, merchant: merchant) } # total_revenue = 160
  let!(:item14) { create(:item, merchant: merchant) } # total_revenue = 160
  let!(:item15) { create(:item, merchant: merchant) } # total_revenue = 180 #=> Top Item 5
  let!(:item16) { create(:item, merchant: merchant) } # total_revenue = 160
  let!(:item17) { create(:item, merchant: merchant) } # total_revenue = 160
  let!(:item18) { create(:item, merchant: merchant) } # total_revenue = 240 #=> Top Item 2
  let!(:item19) { create(:item, merchant: merchant) } # total_revenue = 160
  let!(:item20) { create(:item, merchant: merchant) } # total_revenue = 160

  let!(:invoice1a) {  create(:invoice, :completed, customer: customer1,  created_at: '2021-07-24T17:30:05+0700') }
  let!(:invoice1b) {  create(:invoice, :completed, customer: customer1,  created_at: '2021-07-27T17:30:05+0700') }
  let!(:invoice2a) {  create(:invoice, :completed, customer: customer2,  created_at: '2021-07-26T17:30:05+0700') }
  let!(:invoice2b) {  create(:invoice, :completed, customer: customer2,  created_at: '2021-07-17T17:30:05+0700') }
  let!(:invoice2c) {  create(:invoice, :completed, customer: customer2,  created_at: '2021-07-18T17:30:05+0700') }
  let!(:invoice3a) {  create(:invoice, :completed, customer: customer3,  created_at: '2021-07-29T17:30:05+0700') }
  let!(:invoice3b) {  create(:invoice, :completed, customer: customer3,  created_at: '2021-07-22T17:30:05+0700') }
  let!(:invoice3c) {  create(:invoice, :completed, customer: customer3,  created_at: '2021-07-28T17:30:05+0700') }
  let!(:invoice3d) {  create(:invoice, :completed, customer: customer3,  created_at: '2021-07-02T17:30:05+0700') }
  let!(:invoice3e) {  create(:invoice, :completed, customer: customer3,  created_at: '2021-07-14T17:30:05+0700') }
  let!(:invoice4a) {  create(:invoice, :completed, customer: customer4,  created_at: '2021-07-29T17:30:05+0700') }
  let!(:invoice4b) {  create(:invoice, :completed, customer: customer4,  created_at: '2021-07-17T17:30:05+0700') }
  let!(:invoice4c) {  create(:invoice, :completed, customer: customer4,  created_at: '2021-07-08T17:30:05+0700') }
  let!(:invoice4d) {  create(:invoice, :completed, customer: customer4,  created_at: '2021-07-01T17:30:05+0700') }
  let!(:invoice5a) {  create(:invoice, :completed, customer: customer5,  created_at: '2021-07-04T17:30:05+0700') }
  let!(:invoice6a) {  create(:invoice, :completed, customer: customer6,  created_at: '2021-07-06T17:30:05+0700') }
  let!(:invoice7a) {  create(:invoice, :completed, customer: customer7,  created_at: '2021-07-23T17:30:05+0700') }
  let!(:invoice7b) {  create(:invoice, :completed, customer: customer7,  created_at: '2021-07-22T17:30:05+0700') }
  let!(:invoice8a) {  create(:invoice, :completed, customer: customer8,  created_at: '2021-07-25T17:30:05+0700') }
  let!(:invoice8b) {  create(:invoice, :completed, customer: customer8,  created_at: '2021-07-30T17:30:05+0700') }
  let!(:invoice9a) {  create(:invoice, :completed, customer: customer9,  created_at: '2021-07-14T17:30:05+0700') }
  let!(:invoice10a) { create(:invoice, :completed, customer: customer10, created_at: '2021-07-13T17:30:05+0700') }

  let!(:transaction1a) {  create(:transaction, :failed,  invoice: invoice1a) }
  let!(:transaction1b) {  create(:transaction, :success, invoice: invoice1b) }
  let!(:transaction2a) {  create(:transaction, :success, invoice: invoice2a) }
  let!(:transaction2b) {  create(:transaction, :success, invoice: invoice2b) }
  let!(:transaction2c) {  create(:transaction, :success, invoice: invoice2c) }
  let!(:transaction3a) {  create(:transaction, :success, invoice: invoice3a) }
  let!(:transaction3b) {  create(:transaction, :success, invoice: invoice3b) }
  let!(:transaction3c) {  create(:transaction, :success, invoice: invoice3c) }
  let!(:transaction3d) {  create(:transaction, :success, invoice: invoice3d) }
  let!(:transaction3e) {  create(:transaction, :success, invoice: invoice3e) }
  let!(:transaction4a) {  create(:transaction, :success, invoice: invoice4a) }
  let!(:transaction4b) {  create(:transaction, :success, invoice: invoice4b) }
  let!(:transaction4c) {  create(:transaction, :success, invoice: invoice4c) }
  let!(:transaction4d) {  create(:transaction, :success, invoice: invoice4d) }
  let!(:transaction5a) {  create(:transaction, :success, invoice: invoice5a) }
  let!(:transaction6a) {  create(:transaction, :success, invoice: invoice6a) }
  let!(:transaction7a) {  create(:transaction, :success, invoice: invoice7a) }
  let!(:transaction7b) {  create(:transaction, :success, invoice: invoice7b) }
  let!(:transaction8a) {  create(:transaction, :success, invoice: invoice8a) }
  let!(:transaction8b) {  create(:transaction, :success, invoice: invoice8b) }
  let!(:transaction9a) {  create(:transaction, :success, invoice: invoice9a) }
  let!(:transaction10a) { create(:transaction, :success, invoice: invoice10a) }
                                                                                                                                 # total_revenue only considers successful transaction
  let!(:invoice_item1a_1) {  create(:invoice_item, :pending,  item: item1,  invoice: invoice1a,  quantity: 2,  unit_price: 10) } # total_revenue = 0 (failed transaction)
  let!(:invoice_item1a_2) {  create(:invoice_item, :pending,  item: item1,  invoice: invoice1a,  quantity: 5,  unit_price: 20) } # total_revenue = 100
  let!(:invoice_item1b_1) {  create(:invoice_item, :shipped,  item: item2,  invoice: invoice1b,  quantity: 4,  unit_price: 10) } # total_revenue = 40
  let!(:invoice_item1b_2) {  create(:invoice_item, :shipped,  item: item2,  invoice: invoice1b,  quantity: 5,  unit_price: 20) } # total_revenue = 100
  let!(:invoice_item2a_1) {  create(:invoice_item, :shipped,  item: item3,  invoice: invoice2a,  quantity: 1,  unit_price: 10) } # total_revenue = 10
  let!(:invoice_item2a_2) {  create(:invoice_item, :shipped,  item: item3,  invoice: invoice2a,  quantity: 5,  unit_price: 20) } # total_revenue = 100
  let!(:invoice_item2b_1) {  create(:invoice_item, :shipped,  item: item4,  invoice: invoice2b,  quantity: 3,  unit_price: 10) } # total_revenue = 30
  let!(:invoice_item2b_2) {  create(:invoice_item, :shipped,  item: item4,  invoice: invoice2b,  quantity: 5,  unit_price: 20) } # total_revenue = 100
  let!(:invoice_item2c_1) {  create(:invoice_item, :shipped,  item: item5,  invoice: invoice2c,  quantity: 5,  unit_price: 10) } # total_revenue = 50
  let!(:invoice_item2c_2) {  create(:invoice_item, :shipped,  item: item5,  invoice: invoice2c,  quantity: 10, unit_price: 20) } # total_revenue = 200
  let!(:invoice_item3a_1) {  create(:invoice_item, :shipped,  item: item6,  invoice: invoice3a,  quantity: 6,  unit_price: 10) } # total_revenue = 60
  let!(:invoice_item3a_2) {  create(:invoice_item, :shipped,  item: item6,  invoice: invoice3a,  quantity: 5,  unit_price: 20) } # total_revenue = 100
  let!(:invoice_item3b_1) {  create(:invoice_item, :packaged, item: item7,  invoice: invoice3b,  quantity: 2,  unit_price: 10) } # total_revenue = 20
  let!(:invoice_item3b_2) {  create(:invoice_item, :packaged, item: item7,  invoice: invoice3b,  quantity: 5,  unit_price: 20) } # total_revenue = 100
  let!(:invoice_item3c_1) {  create(:invoice_item, :shipped,  item: item8,  invoice: invoice3c,  quantity: 9,  unit_price: 10) } # total_revenue = 90
  let!(:invoice_item3c_2) {  create(:invoice_item, :shipped,  item: item8,  invoice: invoice3c,  quantity: 6,  unit_price: 20) } # total_revenue = 120
  let!(:invoice_item3d_1) {  create(:invoice_item, :packaged, item: item9,  invoice: invoice3d,  quantity: 1,  unit_price: 10) } # total_revenue = 10
  let!(:invoice_item3e_1) {  create(:invoice_item, :packaged, item: item9,  invoice: invoice3e,  quantity: 5,  unit_price: 20) } # total_revenue = 100
  let!(:invoice_item4a_1) {  create(:invoice_item, :shipped,  item: item10, invoice: invoice4a,  quantity: 3,  unit_price: 10) } # total_revenue = 30
  let!(:invoice_item4a_2) {  create(:invoice_item, :shipped,  item: item10, invoice: invoice4a,  quantity: 5,  unit_price: 20) } # total_revenue = 100
  let!(:invoice_item4b_1) {  create(:invoice_item, :shipped,  item: item11, invoice: invoice4b,  quantity: 5,  unit_price: 10) } # total_revenue = 50
  let!(:invoice_item4b_2) {  create(:invoice_item, :packaged, item: item11, invoice: invoice4b,  quantity: 5,  unit_price: 20) } # total_revenue = 100
  let!(:invoice_item4c_1) {  create(:invoice_item, :packaged, item: item12, invoice: invoice4c,  quantity: 10, unit_price: 10) } # total_revenue = 100
  let!(:invoice_item4c_2) {  create(:invoice_item, :shipped,  item: item12, invoice: invoice4d,  quantity: 5,  unit_price: 20) } # total_revenue = 100
  let!(:invoice_item5a_1) {  create(:invoice_item, :shipped,  item: item13, invoice: invoice5a,  quantity: 6,  unit_price: 10) } # total_revenue = 60
  let!(:invoice_item5a_2) {  create(:invoice_item, :shipped,  item: item13, invoice: invoice5a,  quantity: 5,  unit_price: 20) } # total_revenue = 100
  let!(:invoice_item6a_1) {  create(:invoice_item, :shipped,  item: item14, invoice: invoice6a,  quantity: 6,  unit_price: 10) } # total_revenue = 60
  let!(:invoice_item6a_2) {  create(:invoice_item, :packaged, item: item14, invoice: invoice6a,  quantity: 5,  unit_price: 20) } # total_revenue = 100
  let!(:invoice_item7a_1) {  create(:invoice_item, :shipped,  item: item15, invoice: invoice7a,  quantity: 8,  unit_price: 10) } # total_revenue = 80
  let!(:invoice_item7a_2) {  create(:invoice_item, :packaged, item: item15, invoice: invoice7a,  quantity: 5,  unit_price: 20) } # total_revenue = 100
  let!(:invoice_item7b_1) {  create(:invoice_item, :shipped,  item: item16, invoice: invoice7b,  quantity: 6,  unit_price: 10) } # total_revenue = 60
  let!(:invoice_item7b_2) {  create(:invoice_item, :pending,  item: item16, invoice: invoice7b,  quantity: 5,  unit_price: 20) } # total_revenue = 100
  let!(:invoice_item8a_1) {  create(:invoice_item, :pending,  item: item17, invoice: invoice8a,  quantity: 6,  unit_price: 10) } # total_revenue = 60
  let!(:invoice_item8a_2) {  create(:invoice_item, :pending,  item: item17, invoice: invoice8a,  quantity: 5,  unit_price: 20) } # total_revenue = 100
  let!(:invoice_item8b_1) {  create(:invoice_item, :shipped,  item: item18, invoice: invoice8b,  quantity: 8,  unit_price: 10) } # total_revenue = 80
  let!(:invoice_item8b_2) {  create(:invoice_item, :shipped,  item: item18, invoice: invoice8b,  quantity: 8,  unit_price: 20) } # total_revenue = 160
  let!(:invoice_item9a_1) {  create(:invoice_item, :shipped,  item: item19, invoice: invoice9a,  quantity: 6,  unit_price: 10) } # total_revenue = 60
  let!(:invoice_item9a_2) {  create(:invoice_item, :shipped,  item: item19, invoice: invoice9a,  quantity: 5,  unit_price: 20) } # total_revenue = 100
  let!(:invoice_item10a_1) { create(:invoice_item, :pending,  item: item20, invoice: invoice10a, quantity: 6,  unit_price: 10) } # total_revenue = 60
  let!(:invoice_item10a_2) { create(:invoice_item, :shipped,  item: item20, invoice: invoice10a, quantity: 5,  unit_price: 20) } # total_revenue = 100
end
