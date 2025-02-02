require './spec/support/factory_bot'

# |------------|-------------|----------|----------|-----------|
# |            |             |          |  Total   |           |
# |  Customer  | Transaction |   Item   |  Items   |   Total   |
# |            |    Count    |   Nos.   |   Sold   |  Revenue  |
# |            |   (Rank)    |          |  (Rank)  |  (Rank))  |
# |------------|-------------|----------|----------|-----------|
# | customer1  |   1 (5*)    | 1,2      |  9  (7)  |  240 (6)  |
# | customer2  |   3 (3)     | 3,4,5    |  29 (3)  |  490 (2)  |
# | customer3  |   5 (1)     | 6,7,8,9  |  39 (1)  |  599 (1)  |
# | customer4  |   4 (2)     | 10,11,12 |  32 (2)  |  480 (3)  |
# | customer5  |   1 (5*)    | 13       |  11 (6*) |  160 (7*) |
# | customer6  |   1 (5*)    | 14       |  11 (6*) |  160 (7*) |
# | customer7  |   2 (4*)    | 15,16    |  24 (5)  |  340 (5)  |
# | customer8  |   2 (4*)    | 17,18    |  27 (4)  |  400 (4)  |
# | customer9  |   1 (5*)    | 19       |  11 (6*) |  160 (7*) |
# | customer10 |   1 (5*)    | 20       |  11 (6*) |  160 (7*) |
# |------------|-------------|----------|----------|-----------|
# Note: * Indicates tie

# |--------|-------------|-----------|------------|
# |        | Transaction |   Total   |   Total    |
# | Item   |    Count    |   Sold    |  Revenue   |
# |        |   (Rank)    |  (Rank)   |  (Rank))   |
# |--------|-------------|-----------|------------|
# | item1  |   0 (5)     |   0 (11)  |    0 (12)  |
# | item2  |   1 (4*)    |   9 (7)   |  140 (8)   |
# | item3  |   1 (4*)    |   6 (10*) |  110 (11*) |
# | item4  |   1 (4*)    |   8 (8*)  |  130 (9)   |
# | item5  |   1 (4*)    |  15 (2*)  |  250 (1)   |
# | item6  |   1 (4*)    |  11 (5*)  |  160 (6*)  |
# | item7  |   1 (4*)    |   7 (9)   |  119 (10)  |
# | item8  |   1 (4*)    |  15 (2*)  |  210 (3)   |
# | item9  |   4 (1)     |   6 (10*) |  110 (11*) |
# | item10 |   1 (4*)    |   8 (8*)  |  130 (9)   |
# | item11 |   1 (4*)    |  10 (6)   |  150 (7)   |
# | item12 |   3 (2)     |  14 (3)   |  200 (4)   |
# | item13 |   1 (4*)    |  11 (5*)  |  160 (6*)  |
# | item14 |   1 (4*)    |  11 (5*)  |  160 (6*)  |
# | item15 |   2 (3)     |  13 (4)   |  180 (5)   |
# | item16 |   1 (4*)    |  11 (5*)  |  160 (6*)  |
# | item17 |   1 (4*)    |  11 (5*)  |  160 (6*)  |
# | item18 |   1 (4*)    |  16 (1)   |  240 (2)   |
# | item19 |   1 (4*)    |  11 (5*)  |  160 (6*)  |
# | item20 |   1 (4*)    |  11 (5*)  |  160 (6*)  |
# |--------|-------------|-----------|------------|
# Note: * Indicates tie

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

  let!(:item1) {  create(:item, merchant: merchant) }
  let!(:item2) {  create(:item, merchant: merchant) }
  let!(:item3) {  create(:item, merchant: merchant) }
  let!(:item4) {  create(:item, merchant: merchant) }
  let!(:item5) {  create(:item, merchant: merchant) }
  let!(:item6) {  create(:item, merchant: merchant) }
  let!(:item7) {  create(:item, merchant: merchant) }
  let!(:item8) {  create(:item, merchant: merchant) }
  let!(:item9) {  create(:item, merchant: merchant) }
  let!(:item10) { create(:item, merchant: merchant) }
  let!(:item11) { create(:item, merchant: merchant) }
  let!(:item12) { create(:item, merchant: merchant) }
  let!(:item13) { create(:item, merchant: merchant) }
  let!(:item14) { create(:item, merchant: merchant) }
  let!(:item15) { create(:item, merchant: merchant) }
  let!(:item16) { create(:item, merchant: merchant) }
  let!(:item17) { create(:item, merchant: merchant) }
  let!(:item18) { create(:item, merchant: merchant) }
  let!(:item19) { create(:item, merchant: merchant) }
  let!(:item20) { create(:item, merchant: merchant) }

  let!(:invoice1a) {  create(:invoice, :completed, customer: customer1,  created_at: '2021-07-24T17:30:05+0700') } # 15
  let!(:invoice1b) {  create(:invoice, :completed, customer: customer1,  created_at: '2021-07-27T17:30:05+0700') } # 18
  let!(:invoice2a) {  create(:invoice, :completed, customer: customer2,  created_at: '2021-07-26T17:30:05+0700') } # 17
  let!(:invoice2b) {  create(:invoice, :completed, customer: customer2,  created_at: '2021-07-17T17:30:05+0700') } # 10
  let!(:invoice2c) {  create(:invoice, :completed, customer: customer2,  created_at: '2021-07-18T17:30:05+0700') } # 11
  let!(:invoice3a) {  create(:invoice, :completed, customer: customer3,  created_at: '2021-07-29T17:30:05+0700') } # 20
  let!(:invoice3b) {  create(:invoice, :completed, customer: customer3,  created_at: '2021-07-22T17:30:05+0700') } # 13
  let!(:invoice3c) {  create(:invoice, :completed, customer: customer3,  created_at: '2021-07-28T17:30:05+0700') } # 19
  let!(:invoice3d) {  create(:invoice, :completed, customer: customer3,  created_at: '2021-07-02T17:30:05+0700') } #  2
  let!(:invoice3e) {  create(:invoice, :completed, customer: customer3,  created_at: '2021-07-15T17:30:05+0700') } #  8
  let!(:invoice4a) {  create(:invoice, :completed, customer: customer4,  created_at: '2021-07-29T17:30:05+0705') } # 21
  let!(:invoice4b) {  create(:invoice, :completed, customer: customer4,  created_at: '2021-07-16T17:30:05+0700') } #  9
  let!(:invoice4c) {  create(:invoice, :completed, customer: customer4,  created_at: '2021-07-08T17:30:05+0700') } #  5
  let!(:invoice4d) {  create(:invoice, :completed, customer: customer4,  created_at: '2021-07-01T17:30:05+0700') } #  1
  let!(:invoice5a) {  create(:invoice, :completed, customer: customer5,  created_at: '2021-07-04T17:30:05+0700') } #  3
  let!(:invoice6a) {  create(:invoice, :completed, customer: customer6,  created_at: '2021-07-06T17:30:05+0700') } #  4
  let!(:invoice7a) {  create(:invoice, :completed, customer: customer7,  created_at: '2021-07-23T17:30:05+0700') } # 14
  let!(:invoice7b) {  create(:invoice, :completed, customer: customer7,  created_at: '2021-07-21T17:30:05+0700') } # 12
  let!(:invoice8a) {  create(:invoice, :completed, customer: customer8,  created_at: '2021-07-25T17:30:05+0700') } # 16
  let!(:invoice8b) {  create(:invoice, :completed, customer: customer8,  created_at: '2021-07-30T17:30:05+0700') } # 22
  let!(:invoice9a) {  create(:invoice, :completed, customer: customer9,  created_at: '2021-07-14T17:30:05+0700') } #  7
  let!(:invoice10a) { create(:invoice, :completed, customer: customer10, created_at: '2021-07-13T17:30:05+0700') } #  6

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

  let!(:invoice_item1a_1) {  create(:invoice_item, :pending,  item: item1,  invoice: invoice1a,  quantity: 2,  unit_price: 10) }
  let!(:invoice_item1a_2) {  create(:invoice_item, :pending,  item: item1,  invoice: invoice1a,  quantity: 5,  unit_price: 20) }
  let!(:invoice_item1b_1) {  create(:invoice_item, :shipped,  item: item2,  invoice: invoice1b,  quantity: 4,  unit_price: 10) }
  let!(:invoice_item1b_2) {  create(:invoice_item, :shipped,  item: item2,  invoice: invoice1b,  quantity: 5,  unit_price: 20) }
  let!(:invoice_item2a_1) {  create(:invoice_item, :shipped,  item: item3,  invoice: invoice2a,  quantity: 1,  unit_price: 10) }
  let!(:invoice_item2a_2) {  create(:invoice_item, :shipped,  item: item3,  invoice: invoice2a,  quantity: 5,  unit_price: 20) }
  let!(:invoice_item2b_1) {  create(:invoice_item, :shipped,  item: item4,  invoice: invoice2b,  quantity: 3,  unit_price: 10) }
  let!(:invoice_item2b_2) {  create(:invoice_item, :shipped,  item: item4,  invoice: invoice2b,  quantity: 5,  unit_price: 20) }
  let!(:invoice_item2c_1) {  create(:invoice_item, :shipped,  item: item5,  invoice: invoice2c,  quantity: 5,  unit_price: 10) }
  let!(:invoice_item2c_2) {  create(:invoice_item, :shipped,  item: item5,  invoice: invoice2c,  quantity: 10, unit_price: 20) }
  let!(:invoice_item3a_1) {  create(:invoice_item, :shipped,  item: item6,  invoice: invoice3a,  quantity: 6,  unit_price: 10) }
  let!(:invoice_item3a_2) {  create(:invoice_item, :shipped,  item: item6,  invoice: invoice3a,  quantity: 5,  unit_price: 20) }
  let!(:invoice_item3b_1) {  create(:invoice_item, :packaged, item: item7,  invoice: invoice3b,  quantity: 7,  unit_price: 17) }
  let!(:invoice_item3b_2) {  create(:invoice_item, :packaged, item: item9,  invoice: invoice3b,  quantity: 1,  unit_price: 20) }
  let!(:invoice_item3c_1) {  create(:invoice_item, :shipped,  item: item8,  invoice: invoice3c,  quantity: 15, unit_price: 14) }
  let!(:invoice_item3c_2) {  create(:invoice_item, :shipped,  item: item9,  invoice: invoice3c,  quantity: 1,  unit_price: 20) }
  let!(:invoice_item3d_1) {  create(:invoice_item, :packaged, item: item9,  invoice: invoice3d,  quantity: 1,  unit_price: 10) }
  let!(:invoice_item3e_1) {  create(:invoice_item, :packaged, item: item9,  invoice: invoice3e,  quantity: 3,  unit_price: 20) }
  let!(:invoice_item4a_1) {  create(:invoice_item, :shipped,  item: item10, invoice: invoice4a,  quantity: 3,  unit_price: 10) }
  let!(:invoice_item4a_2) {  create(:invoice_item, :shipped,  item: item10, invoice: invoice4a,  quantity: 5,  unit_price: 20) }
  let!(:invoice_item4b_1) {  create(:invoice_item, :shipped,  item: item11, invoice: invoice4b,  quantity: 5,  unit_price: 10) }
  let!(:invoice_item4b_2) {  create(:invoice_item, :packaged, item: item11, invoice: invoice4b,  quantity: 5,  unit_price: 20) }
  let!(:invoice_item4b_3) {  create(:invoice_item, :shipped,  item: item12, invoice: invoice4b,  quantity: 5,  unit_price: 10) }
  let!(:invoice_item4c_1) {  create(:invoice_item, :packaged, item: item12, invoice: invoice4c,  quantity: 5,  unit_price: 10) }
  let!(:invoice_item4c_2) {  create(:invoice_item, :shipped,  item: item12, invoice: invoice4d,  quantity: 4,  unit_price: 25) }
  let!(:invoice_item5a_1) {  create(:invoice_item, :shipped,  item: item13, invoice: invoice5a,  quantity: 6,  unit_price: 10) }
  let!(:invoice_item5a_2) {  create(:invoice_item, :shipped,  item: item13, invoice: invoice5a,  quantity: 5,  unit_price: 20) }
  let!(:invoice_item6a_1) {  create(:invoice_item, :shipped,  item: item14, invoice: invoice6a,  quantity: 6,  unit_price: 10) }
  let!(:invoice_item6a_2) {  create(:invoice_item, :packaged, item: item14, invoice: invoice6a,  quantity: 5,  unit_price: 20) }
  let!(:invoice_item7a_1) {  create(:invoice_item, :shipped,  item: item15, invoice: invoice7a,  quantity: 8,  unit_price: 10) }
  let!(:invoice_item7a_2) {  create(:invoice_item, :packaged, item: item15, invoice: invoice7a,  quantity: 3,  unit_price: 20) }
  let!(:invoice_item7a_3) {  create(:invoice_item, :shipped,  item: item15, invoice: invoice7b,  quantity: 2,  unit_price: 20) }
  let!(:invoice_item7b_1) {  create(:invoice_item, :shipped,  item: item16, invoice: invoice7b,  quantity: 6,  unit_price: 10) }
  let!(:invoice_item7b_2) {  create(:invoice_item, :pending,  item: item16, invoice: invoice7b,  quantity: 5,  unit_price: 20) }
  let!(:invoice_item8a_1) {  create(:invoice_item, :pending,  item: item17, invoice: invoice8a,  quantity: 6,  unit_price: 10) }
  let!(:invoice_item8a_2) {  create(:invoice_item, :pending,  item: item17, invoice: invoice8a,  quantity: 5,  unit_price: 20) }
  let!(:invoice_item8b_1) {  create(:invoice_item, :shipped,  item: item18, invoice: invoice8b,  quantity: 8,  unit_price: 10) }
  let!(:invoice_item8b_2) {  create(:invoice_item, :shipped,  item: item18, invoice: invoice8b,  quantity: 8,  unit_price: 20) }
  let!(:invoice_item9a_1) {  create(:invoice_item, :shipped,  item: item19, invoice: invoice9a,  quantity: 6,  unit_price: 10) }
  let!(:invoice_item9a_2) {  create(:invoice_item, :shipped,  item: item19, invoice: invoice9a,  quantity: 5,  unit_price: 20) }
  let!(:invoice_item10a_1) { create(:invoice_item, :pending,  item: item20, invoice: invoice10a, quantity: 6,  unit_price: 10) }
  let!(:invoice_item10a_2) { create(:invoice_item, :shipped,  item: item20, invoice: invoice10a, quantity: 5,  unit_price: 20) }
end
