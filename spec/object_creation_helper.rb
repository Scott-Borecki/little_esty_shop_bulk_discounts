def create_factories
  #############
  # CUSTOMERS #
  #############

  let!(:customer1) { create(:customer) }
  let!(:customer2) { create(:customer) }
  let!(:customer3) { create(:customer) }
  let!(:customer4) { create(:customer) }
  let!(:customer5) { create(:customer) }
  let!(:customer6) { create(:customer) }

  #############
  # MERCHANTS #
  #############

  let!(:merchant1) { create(:enabled_merchant) }
  let!(:merchant2) { create(:enabled_merchant) }
  let!(:merchant3) { create(:enabled_merchant) }
  let!(:merchant4) { create(:disabled_merchant) }
  let!(:merchant5) { create(:disabled_merchant) }
  let!(:merchant6) { create(:enabled_merchant) }

  #########
  # ITEMS #
  #########

  let!(:item1a) { create(:item, merchant: merchant1) }
  let!(:item1b) { create(:item, merchant: merchant1) }

  let!(:item2) {  create(:item, merchant: merchant2) }
  let!(:item2a) { create(:item, merchant: merchant2) }

  let!(:item3) { create(:item, merchant: merchant3) }
  let!(:item3a) { create(:item, merchant: merchant3) }
  let!(:item3b) { create(:item, merchant: merchant3) }

  let!(:item4) { create(:item, merchant: merchant4) }
  let!(:item4a) { create(:item, merchant: merchant4) }

  let!(:item5) { create(:item, merchant: merchant5) }
  let!(:item5a) { create(:item, merchant: merchant5) }

  let!(:item6) { create(:item, merchant: merchant6) }
  let!(:item6a) { create(:item, merchant: merchant6) }

  ############
  # INVOICES #
  ############

  let!(:invoice1) { create(:invoice, :completed, customer: customer1) }

  let!(:invoice2a) { create(:invoice, :completed, customer: customer2) }
  let!(:invoice2b) { create(:invoice, :completed, customer: customer2) }
  let!(:invoice2c) { create(:invoice, :completed, customer: customer2) }
  let!(:invoice2d) { create(:invoice, :completed, customer: customer2) }
  let!(:invoice2e) { create(:invoice, :completed, customer: customer2) }

  let!(:invoice3) {  create(:invoice, :completed, customer: customer3) }

  let!(:invoice4a) { create(:invoice, :completed, customer: customer4) }
  let!(:invoice4b) { create(:invoice, :completed, customer: customer4) }
  let!(:invoice4c) { create(:invoice, :completed, customer: customer4) }
  let!(:invoice4d) { create(:invoice, :completed, customer: customer4) }

  let!(:invoice5a) { create(:invoice, :completed, customer: customer5) }
  let!(:invoice5b) { create(:invoice, :completed, customer: customer5) }

  let!(:invoice6a) { create(:invoice, :completed, customer: customer6, created_at: "2021-07-29T17:30:05+0700") }
  let!(:invoice6b) { create(:invoice, :completed, customer: customer6, created_at: "2021-07-27T17:30:05+0700") }
  let!(:invoice6c) { create(:invoice, :completed, customer: customer6, created_at: "2021-07-25T17:30:05+0700") }

  ################
  # TRANSACTIONS #
  ################

  let!(:transaction1) { create(:transaction, :failed, invoice: invoice1) }

  let!(:transaction2a) { create(:transaction, :success, invoice: invoice2a) }
  let!(:transaction2b) { create(:transaction, :success, invoice: invoice2b) }
  let!(:transaction2c) { create(:transaction, :success, invoice: invoice2c) }
  let!(:transaction2d) { create(:transaction, :success, invoice: invoice2d) }
  let!(:transaction2e) { create(:transaction, :success, invoice: invoice2e) }

  let!(:transaction3) {  create(:transaction, :success, invoice: invoice3) }

  let!(:transaction4a) { create(:transaction, :success, invoice: invoice4a) }
  let!(:transaction4b) { create(:transaction, :success, invoice: invoice4b) }
  let!(:transaction4c) { create(:transaction, :success, invoice: invoice4c) }
  let!(:transaction4d) { create(:transaction, :success, invoice: invoice4d) }

  let!(:transaction5a) { create(:transaction, :success, invoice: invoice5a) }
  let!(:transaction5b) { create(:transaction, :success, invoice: invoice5b) }

  let!(:transaction6a) { create(:transaction, :success, invoice: invoice6a) }
  let!(:transaction6b) { create(:transaction, :success, invoice: invoice6b) }
  let!(:transaction6c) { create(:transaction, :success, invoice: invoice6c) }

  #################
  # INVOICE ITEMS #
  #################

  # INVOICE ITEMS - item1a/1b, merchant1, invoice1, failed transaction
  let!(:invoice_item1a) { create(:invoice_item, :pending,  item: item1a, invoice: invoice1,  quantity: 10,  unit_price: 10) }
    #=> ii1a_total_revenue        = 100
    #=> bulk_discount1a_revenue   = 100
    #=> bulk_discount1b_revenue   = 100
  let!(:invoice_item1b) { create(:invoice_item, :pending,  item: item1b, invoice: invoice1,  quantity: 20,  unit_price: 20) }
    #=> ii1a_total_revenue        = 400
    #=> bulk_discount1a_revenue   = 360
    #=> bulk_discount1b_revenue   = 320

      #=> invoice1_revenue        = 500
      #=> merchant1_revenue       = 0 (failed transaction)
      #=> bulk_discount1a_revenue = 450
      #=> bulk_discount1b_revenue = 420 <= Revenue with applied discount

  # INVOICE ITEMS - item2/2a, merchant2, various invoices
  let!(:invoice_item2a_1) { create(:invoice_item, :shipped,  item: item2,  invoice: invoice2a, quantity: 4,   unit_price: 10) } # potential_revenue = 40
  let!(:invoice_item2a_2) { create(:invoice_item, :shipped,  item: item2a, invoice: invoice2a, quantity: 1,   unit_price: 20) } # potential_revenue = 20
  let!(:invoice_item2b) {   create(:invoice_item, :shipped,  item: item2,  invoice: invoice2b, quantity: 1,   unit_price: 20) } # potential_revenue = 20
  let!(:invoice_item2c) {   create(:invoice_item, :shipped,  item: item2,  invoice: invoice2c, quantity: 1,   unit_price: 20) } # potential_revenue = 20
  let!(:invoice_item2d) {   create(:invoice_item, :shipped,  item: item2,  invoice: invoice2d, quantity: 1,   unit_price: 20) } # potential_revenue = 20
  let!(:invoice_item2e) {   create(:invoice_item, :shipped,  item: item2,  invoice: invoice2e, quantity: 1,   unit_price: 20) } # potential_revenue = 20
    #=> merchant2_potential_revenue = 140

  # INVOICE ITEMS - item3, merchant3, invoice3
  let!(:invoice_item3) { create(:invoice_item, :packaged, item: item3, invoice: invoice3,  quantity: 15,  unit_price: 10) }
    #=> ii3a_total_revenue        = 150
    #=> bulk_discount3a_revenue   = 150
    #=> bulk_discount3b_revenue   = 120 <= Max applied discount
    #=> bulk_discount3c_revenue   = 150
  let!(:invoice_item3a) { create(:invoice_item, :packaged, item: item3a, invoice: invoice3,  quantity: 25,  unit_price: 20) }
    #=> ii3b_total_revenue        = 500
    #=> bulk_discount3a_revenue   = 450
    #=> bulk_discount3b_revenue   = 400
    #=> bulk_discount3c_revenue   = 350 <= Max applied discount
  let!(:invoice_item3b) { create(:invoice_item, :packaged, item: item3b, invoice: invoice3,  quantity: 3,  unit_price: 20) }
    #=> ii3b_total_revenue        = 60
    #=> bulk_discount3a_revenue   = 60
    #=> bulk_discount3b_revenue   = 60
    #=> bulk_discount3c_revenue   = 60

      #=> invoice3_revenue         = 710
      #=> merchant3_revenue        = 710
      #=> applied_discount_revenue = 530

  # INVOICE ITEMS - item4, merchant4, various invoices
  let!(:invoice_item4a) { create(:invoice_item, :shipped,  item: item4,  invoice: invoice4a, quantity: 3,  unit_price: 10) } # potential_revenue = 30
  let!(:invoice_item4b) { create(:invoice_item, :shipped,  item: item4a, invoice: invoice4a, quantity: 2,  unit_price: 20) } # potential_revenue = 40
  let!(:invoice_item4c) { create(:invoice_item, :shipped,  item: item4,  invoice: invoice4b, quantity: 1,  unit_price: 20) } # potential_revenue = 20
  let!(:invoice_item4d) { create(:invoice_item, :shipped,  item: item4,  invoice: invoice4c, quantity: 1,  unit_price: 20) } # potential_revenue = 20
  let!(:invoice_item4e) { create(:invoice_item, :shipped,  item: item4,  invoice: invoice4d, quantity: 1,  unit_price: 20) } # potential_revenue = 20
    #=> merchant4_potential_revenue = 130

  # INVOICE ITEMS - item5/5a, merchant5, various invoices
  let!(:invoice_item5a_1) { create(:invoice_item, :packaged, item: item5,  invoice: invoice5a, quantity: 5,  unit_price: 10) } # potential_revenue = 50
  let!(:invoice_item5a_2) { create(:invoice_item, :packaged, item: item5a, invoice: invoice5a, quantity: 3,  unit_price: 20) } # potential_revenue = 60
  let!(:invoice_item5b) {   create(:invoice_item, :packaged, item: item5,  invoice: invoice5b, quantity: 2,  unit_price: 20) } # potential_revenue = 40
    #=> merchant5_potential_revenue = 150

  # INVOICE ITEMS - item6/6a, merchant6, various invoices
  let!(:invoice_item6a_1) { create(:invoice_item, :shipped,  item: item6,  invoice: invoice6a, quantity: 6,  unit_price: 10) } # potential_revenue = 60
  let!(:invoice_item6a_2) { create(:invoice_item, :shipped,  item: item6a, invoice: invoice6a, quantity: 5,  unit_price: 20) } # potential_revenue = 100
  let!(:invoice_item6b_1) { create(:invoice_item, :shipped,  item: item6,  invoice: invoice6b, quantity: 6,  unit_price: 10) } # potential_revenue = 60
  let!(:invoice_item6b_2) { create(:invoice_item, :shipped,  item: item6a, invoice: invoice6b, quantity: 10, unit_price: 20) } # potential_revenue = 200
  let!(:invoice_item6c_1) { create(:invoice_item, :shipped,  item: item6,  invoice: invoice6c, quantity: 6,  unit_price: 10) } # potential_revenue = 60
  let!(:invoice_item6c_2) { create(:invoice_item, :shipped,  item: item6a, invoice: invoice6c, quantity: 10, unit_price: 20) } # potential_revenue = 200
    #=> merchant6_potential_revenue = 680

  # BULK DISCOUNTS - merchant1
  let!(:bulk_discount1a) { create(:bulk_discount, merchant: merchant1, quantity_threshold: 11,  percentage_discount: 10) }
  let!(:bulk_discount1b) { create(:bulk_discount, merchant: merchant1, quantity_threshold: 19,  percentage_discount: 20) }

  # BULK DISCOUNTS - merchant3
  let!(:bulk_discount3a) { create(:bulk_discount, merchant: merchant3, quantity_threshold: 19,  percentage_discount: 10) }
  let!(:bulk_discount3b) { create(:bulk_discount, merchant: merchant3, quantity_threshold: 5,   percentage_discount: 20) }
  let!(:bulk_discount3c) { create(:bulk_discount, merchant: merchant3, quantity_threshold: 21,  percentage_discount: 30) }
end

def create_objects_top_revenue_day
  let!(:merchant) { create(:enabled_merchant) }

  let!(:customer) { create(:customer) }

  let!(:item6) { create(:item, merchant: merchant) }
  let!(:item6a) { create(:item, merchant: merchant) }

  let!(:invoice6a) { create(:invoice, :completed, customer: customer, created_at: "2021-07-29T17:30:05+0700") }
  let!(:invoice6b) { create(:invoice, :completed, customer: customer, created_at: "2021-07-27T17:30:05+0700") }
  let!(:invoice6c) { create(:invoice, :completed, customer: customer, created_at: "2021-07-25T17:30:05+0700") }

  let!(:transaction6a) { create(:transaction, :success, invoice: invoice6a) }
  let!(:transaction6b) { create(:transaction, :success, invoice: invoice6b) }
  let!(:transaction6c) { create(:transaction, :success, invoice: invoice6c) }

  let!(:invoice_item6a_1) { create(:invoice_item, :shipped,  item: item6,  invoice: invoice6a, quantity: 6,  unit_price: 10) }
  let!(:invoice_item6a_2) { create(:invoice_item, :shipped,  item: item6a, invoice: invoice6a, quantity: 5,  unit_price: 20) }
  let!(:invoice_item6b_1) { create(:invoice_item, :shipped,  item: item6,  invoice: invoice6b, quantity: 6,  unit_price: 10) }
  let!(:invoice_item6b_2) { create(:invoice_item, :shipped,  item: item6a, invoice: invoice6b, quantity: 10, unit_price: 20) }
  let!(:invoice_item6c_1) { create(:invoice_item, :shipped,  item: item6,  invoice: invoice6c, quantity: 6,  unit_price: 10) }
  let!(:invoice_item6c_2) { create(:invoice_item, :shipped,  item: item6a, invoice: invoice6c, quantity: 10, unit_price: 20) }
end

def create_factories_merchant_with_many_customers_and_items
  let!(:customer1) {  create(:customer) } # Transaction_count = 1
  let!(:customer2) {  create(:customer) } # Transaction_count = 3
  let!(:customer3) {  create(:customer) } # Transaction_count = 5
  let!(:customer4) {  create(:customer) } # Transaction_count = 4
  let!(:customer5) {  create(:customer) } # Transaction_count = 1
  let!(:customer6) {  create(:customer) } # Transaction_count = 1
  let!(:customer7) {  create(:customer) } # Transaction_count = 2
  let!(:customer8) {  create(:customer) } # Transaction_count = 2
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

  let!(:invoice1a) {  create(:invoice, :completed, customer: customer1) }
  let!(:invoice1b) {  create(:invoice, :completed, customer: customer1) }
  let!(:invoice2a) {  create(:invoice, :completed, customer: customer2) }
  let!(:invoice2b) {  create(:invoice, :completed, customer: customer2) }
  let!(:invoice2c) {  create(:invoice, :completed, customer: customer2) }
  let!(:invoice3a) {  create(:invoice, :completed, customer: customer3) }
  let!(:invoice3b) {  create(:invoice, :completed, customer: customer3) }
  let!(:invoice3c) {  create(:invoice, :completed, customer: customer3) }
  let!(:invoice3d) {  create(:invoice, :completed, customer: customer3) }
  let!(:invoice4a) {  create(:invoice, :completed, customer: customer4) }
  let!(:invoice4b) {  create(:invoice, :completed, customer: customer4) }
  let!(:invoice4c) {  create(:invoice, :completed, customer: customer4) }
  let!(:invoice5a) {  create(:invoice, :completed, customer: customer5) }
  let!(:invoice6a) {  create(:invoice, :completed, customer: customer6) }
  let!(:invoice7a) {  create(:invoice, :completed, customer: customer7) }
  let!(:invoice7b) {  create(:invoice, :completed, customer: customer7) }
  let!(:invoice8a) {  create(:invoice, :completed, customer: customer8) }
  let!(:invoice8b) {  create(:invoice, :completed, customer: customer8) }
  let!(:invoice9a) {  create(:invoice, :completed, customer: customer9) }
  let!(:invoice10a) { create(:invoice, :completed, customer: customer10) }

  let!(:transaction1a) {  create(:transaction, :failed,  invoice: invoice1a) }
  let!(:transaction1b) {  create(:transaction, :success, invoice: invoice1b) }
  let!(:transaction2a) {  create(:transaction, :success, invoice: invoice2a) }
  let!(:transaction2b) {  create(:transaction, :success, invoice: invoice2b) }
  let!(:transaction2c) {  create(:transaction, :success, invoice: invoice2c) }
  let!(:transaction3a) {  create(:transaction, :success, invoice: invoice3a) }
  let!(:transaction3b) {  create(:transaction, :success, invoice: invoice3b) }
  let!(:transaction3c) {  create(:transaction, :success, invoice: invoice3c) }
  let!(:transaction3d) {  create(:transaction, :success, invoice: invoice3d) }
  let!(:transaction3e) {  create(:transaction, :success, invoice: invoice3d) }
  let!(:transaction4a) {  create(:transaction, :success, invoice: invoice4a) }
  let!(:transaction4b) {  create(:transaction, :success, invoice: invoice4b) }
  let!(:transaction4c) {  create(:transaction, :success, invoice: invoice4c) }
  let!(:transaction4d) {  create(:transaction, :success, invoice: invoice4c) }
  let!(:transaction5a) {  create(:transaction, :success, invoice: invoice5a) }
  let!(:transaction6a) {  create(:transaction, :success, invoice: invoice6a) }
  let!(:transaction7a) {  create(:transaction, :success, invoice: invoice7a) }
  let!(:transaction7b) {  create(:transaction, :success, invoice: invoice7b) }
  let!(:transaction8a) {  create(:transaction, :success, invoice: invoice8a) }
  let!(:transaction8b) {  create(:transaction, :success, invoice: invoice8b) }
  let!(:transaction9a) {  create(:transaction, :success, invoice: invoice9a) }
  let!(:transaction10a) { create(:transaction, :success, invoice: invoice10a) }

  let!(:invoice_item1a) {  create(:invoice_item, :pending,  item: item1,  invoice: invoice1a,  quantity: 2, unit_price: 10) }
  let!(:invoice_item1b) {  create(:invoice_item, :pending,  item: item1,  invoice: invoice1a,  quantity: 5, unit_price: 20) }
  let!(:invoice_item2a) {  create(:invoice_item, :pending,  item: item2,  invoice: invoice1b,  quantity: 4, unit_price: 10) }
  let!(:invoice_item2b) {  create(:invoice_item, :pending,  item: item2,  invoice: invoice1b,  quantity: 5, unit_price: 20) }
  let!(:invoice_item3a) {  create(:invoice_item, :pending,  item: item3,  invoice: invoice2a,  quantity: 1, unit_price: 10) }
  let!(:invoice_item3b) {  create(:invoice_item, :pending,  item: item3,  invoice: invoice2a,  quantity: 5, unit_price: 20) }
  let!(:invoice_item4a) {  create(:invoice_item, :shipped,  item: item4,  invoice: invoice2b,  quantity: 3, unit_price: 10) }
  let!(:invoice_item4b) {  create(:invoice_item, :shipped,  item: item4,  invoice: invoice2b,  quantity: 5, unit_price: 20) }
  let!(:invoice_item5a) {  create(:invoice_item, :shipped,  item: item5,  invoice: invoice2c,  quantity: 5, unit_price: 10) }
  let!(:invoice_item5b) {  create(:invoice_item, :shipped,  item: item5,  invoice: invoice2c,  quantity: 5, unit_price: 20) }
  let!(:invoice_item6a) {  create(:invoice_item, :shipped,  item: item6,  invoice: invoice3a,  quantity: 6, unit_price: 10) }
  let!(:invoice_item6b) {  create(:invoice_item, :shipped,  item: item6,  invoice: invoice3a,  quantity: 5, unit_price: 20) }
  let!(:invoice_item7a) {  create(:invoice_item, :packaged, item: item7,  invoice: invoice3b,  quantity: 2, unit_price: 10) }
  let!(:invoice_item7b) {  create(:invoice_item, :packaged, item: item7,  invoice: invoice3b,  quantity: 5, unit_price: 20) }
  let!(:invoice_item8a) {  create(:invoice_item, :packaged, item: item8,  invoice: invoice3c,  quantity: 4, unit_price: 10) }
  let!(:invoice_item8b) {  create(:invoice_item, :packaged, item: item8,  invoice: invoice3c,  quantity: 5, unit_price: 20) }
  let!(:invoice_item9a) {  create(:invoice_item, :packaged, item: item9,  invoice: invoice3d,  quantity: 1, unit_price: 10) }
  let!(:invoice_item9b) {  create(:invoice_item, :packaged, item: item9,  invoice: invoice3d,  quantity: 5, unit_price: 20) }
  let!(:invoice_item10a) { create(:invoice_item, :shipped,  item: item10, invoice: invoice4a,  quantity: 3, unit_price: 10) }
  let!(:invoice_item10b) { create(:invoice_item, :shipped,  item: item10, invoice: invoice4a,  quantity: 5, unit_price: 20) }
  let!(:invoice_item11a) { create(:invoice_item, :shipped,  item: item11, invoice: invoice4b,  quantity: 5, unit_price: 10) }
  let!(:invoice_item11b) { create(:invoice_item, :packaged, item: item11, invoice: invoice4b,  quantity: 5, unit_price: 20) }
  let!(:invoice_item12a) { create(:invoice_item, :packaged, item: item12, invoice: invoice4c,  quantity: 6, unit_price: 10) }
  let!(:invoice_item12b) { create(:invoice_item, :packaged, item: item12, invoice: invoice4c,  quantity: 5, unit_price: 20) }
  let!(:invoice_item13a) { create(:invoice_item, :packaged, item: item13, invoice: invoice5a,  quantity: 6, unit_price: 10) }
  let!(:invoice_item13b) { create(:invoice_item, :packaged, item: item13, invoice: invoice5a,  quantity: 5, unit_price: 20) }
  let!(:invoice_item14a) { create(:invoice_item, :packaged, item: item14, invoice: invoice6a,  quantity: 6, unit_price: 10) }
  let!(:invoice_item14b) { create(:invoice_item, :packaged, item: item14, invoice: invoice6a,  quantity: 5, unit_price: 20) }
  let!(:invoice_item15a) { create(:invoice_item, :packaged, item: item15, invoice: invoice7a,  quantity: 6, unit_price: 10) }
  let!(:invoice_item15b) { create(:invoice_item, :packaged, item: item15, invoice: invoice7a,  quantity: 5, unit_price: 20) }
  let!(:invoice_item16a) { create(:invoice_item, :pending,  item: item16, invoice: invoice7b,  quantity: 6, unit_price: 10) }
  let!(:invoice_item16b) { create(:invoice_item, :pending,  item: item16, invoice: invoice7b,  quantity: 5, unit_price: 20) }
  let!(:invoice_item17a) { create(:invoice_item, :pending,  item: item17, invoice: invoice8a,  quantity: 6, unit_price: 10) }
  let!(:invoice_item17b) { create(:invoice_item, :pending,  item: item17, invoice: invoice8a,  quantity: 5, unit_price: 20) }
  let!(:invoice_item18a) { create(:invoice_item, :pending,  item: item18, invoice: invoice8b,  quantity: 6, unit_price: 10) }
  let!(:invoice_item18b) { create(:invoice_item, :pending,  item: item18, invoice: invoice8b,  quantity: 5, unit_price: 20) }
  let!(:invoice_item19a) { create(:invoice_item, :pending,  item: item19, invoice: invoice9a,  quantity: 6, unit_price: 10) }
  let!(:invoice_item19b) { create(:invoice_item, :pending,  item: item19, invoice: invoice9a,  quantity: 5, unit_price: 20) }
  let!(:invoice_item20a) { create(:invoice_item, :pending,  item: item20, invoice: invoice10a, quantity: 6, unit_price: 10) }
  let!(:invoice_item20b) { create(:invoice_item, :pending,  item: item20, invoice: invoice10a, quantity: 5, unit_price: 20) }
end

def holidays_parsed
  [{:date=>"2021-09-06",
    :localName=>"Labor Day",
    :name=>"Labour Day",
    :countryCode=>"US",
    :fixed=>false,
    :global=>true,
    :counties=>nil,
    :launchYear=>nil,
    :types=>["Public"]},
   {:date=>"2021-10-11",
    :localName=>"Columbus Day",
    :name=>"Columbus Day",
    :countryCode=>"US",
    :fixed=>false,
    :global=>false,
    :counties=>
     ["US-AL",
      "US-AZ",
      "US-CO",
      "US-CT",
      "US-DC",
      "US-GA",
      "US-ID",
      "US-IL",
      "US-IN",
      "US-IA",
      "US-KS",
      "US-KY",
      "US-LA",
      "US-ME",
      "US-MD",
      "US-MA",
      "US-MS",
      "US-MO",
      "US-MT",
      "US-NE",
      "US-NH",
      "US-NJ",
      "US-NM",
      "US-NY",
      "US-NC",
      "US-OH",
      "US-OK",
      "US-PA",
      "US-RI",
      "US-SC",
      "US-TN",
      "US-UT",
      "US-VA",
      "US-WV"],
    :launchYear=>nil,
    :types=>["Public"]},
   {:date=>"2021-11-11",
    :localName=>"Veterans Day",
    :name=>"Veterans Day",
    :countryCode=>"US",
    :fixed=>false,
    :global=>true,
    :counties=>nil,
    :launchYear=>nil,
    :types=>["Public"]},
   {:date=>"2021-11-25",
    :localName=>"Thanksgiving Day",
    :name=>"Thanksgiving Day",
    :countryCode=>"US",
    :fixed=>false,
    :global=>true,
    :counties=>nil,
    :launchYear=>1863,
    :types=>["Public"]},
   {:date=>"2021-12-24",
    :localName=>"Christmas Day",
    :name=>"Christmas Day",
    :countryCode=>"US",
    :fixed=>false,
    :global=>true,
    :counties=>nil,
    :launchYear=>nil,
    :types=>["Public"]},
   {:date=>"2021-12-31",
    :localName=>"New Year's Day",
    :name=>"New Year's Day",
    :countryCode=>"US",
    :fixed=>false,
    :global=>true,
    :counties=>nil,
    :launchYear=>nil,
    :types=>["Public"]},
   {:date=>"2022-01-17",
    :localName=>"Martin Luther King, Jr. Day",
    :name=>"Martin Luther King, Jr. Day",
    :countryCode=>"US",
    :fixed=>false,
    :global=>true,
    :counties=>nil,
    :launchYear=>nil,
    :types=>["Public"]},
   {:date=>"2022-02-21",
    :localName=>"Presidents Day",
    :name=>"Washington's Birthday",
    :countryCode=>"US",
    :fixed=>false,
    :global=>true,
    :counties=>nil,
    :launchYear=>nil,
    :types=>["Public"]},
   {:date=>"2022-04-15",
    :localName=>"Good Friday",
    :name=>"Good Friday",
    :countryCode=>"US",
    :fixed=>false,
    :global=>false,
    :counties=>["US-CT", "US-DE", "US-HI", "US-IN", "US-KY", "US-LA", "US-NC", "US-ND", "US-NJ", "US-TN"],
    :launchYear=>nil,
    :types=>["Public"]},
   {:date=>"2022-05-30",
    :localName=>"Memorial Day",
    :name=>"Memorial Day",
    :countryCode=>"US",
    :fixed=>false,
    :global=>true,
    :counties=>nil,
    :launchYear=>nil,
    :types=>["Public"]},
   {:date=>"2022-06-20",
    :localName=>"Juneteenth",
    :name=>"Juneteenth",
    :countryCode=>"US",
    :fixed=>false,
    :global=>true,
    :counties=>nil,
    :launchYear=>2021,
    :types=>["Public"]},
   {:date=>"2022-07-04",
    :localName=>"Independence Day",
    :name=>"Independence Day",
    :countryCode=>"US",
    :fixed=>false,
    :global=>true,
    :counties=>nil,
    :launchYear=>nil,
    :types=>["Public"]}
  ]
end
