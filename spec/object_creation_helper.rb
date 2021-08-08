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
