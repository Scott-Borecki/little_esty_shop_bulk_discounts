require 'rails_helper'

describe "merchant items index" do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @merchant2 = Merchant.create!(name: 'Jewelry')

    @item1 = Item.create!(name: 'Shampoo', description: 'This washes your hair', unit_price: 10, merchant_id: @merchant1.id, status: 1)
    @item2 = Item.create!(name: 'Conditioner', description: 'This makes your hair shiny', unit_price: 8, merchant_id: @merchant1.id)
    @item3 = Item.create!(name: 'Brush', description: 'This takes out tangles', unit_price: 5, merchant_id: @merchant1.id)
    @item4 = Item.create!(name: 'Hair tie', description: 'This holds up your hair', unit_price: 1, merchant_id: @merchant1.id)
    @item7 = Item.create!(name: 'Scrunchie', description: 'This holds up your hair but is bigger', unit_price: 3, merchant_id: @merchant1.id)
    @item8 = Item.create!(name: 'Butterfly Clip', description: 'This holds up your hair but in a clip', unit_price: 5, merchant_id: @merchant1.id)

    @item5 = Item.create!(name: 'Bracelet', description: 'Wrist bling', unit_price: 200, merchant_id: @merchant2.id)
    @item6 = Item.create!(name: 'Necklace', description: 'Neck bling', unit_price: 300, merchant_id: @merchant2.id)

    @customer1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
    @customer2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
    @customer3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
    @customer4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
    @customer5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
    @customer6 = Customer.create!(first_name: 'Herber', last_name: 'Coon')

    @invoice1 = Invoice.create!(customer_id: @customer1.id, status: 2, created_at: '2012-03-27 14:54:09')
    @invoice2 = Invoice.create!(customer_id: @customer1.id, status: 2, created_at: '2012-03-28 14:54:09')
    @invoice3 = Invoice.create!(customer_id: @customer2.id, status: 2)
    @invoice4 = Invoice.create!(customer_id: @customer3.id, status: 2)
    @invoice5 = Invoice.create!(customer_id: @customer4.id, status: 2)
    @invoice6 = Invoice.create!(customer_id: @customer5.id, status: 2)
    @invoice7 = Invoice.create!(customer_id: @customer6.id, status: 2)

    @ii1 = InvoiceItem.create!(invoice_id: @invoice1.id, item_id: @item1.id, quantity: 9, unit_price: 10, status: 0)
    @ii2 = InvoiceItem.create!(invoice_id: @invoice2.id, item_id: @item1.id, quantity: 1, unit_price: 10, status: 0)
    @ii3 = InvoiceItem.create!(invoice_id: @invoice3.id, item_id: @item2.id, quantity: 2, unit_price: 8, status: 2)
    @ii4 = InvoiceItem.create!(invoice_id: @invoice4.id, item_id: @item3.id, quantity: 3, unit_price: 5, status: 1)
    @ii6 = InvoiceItem.create!(invoice_id: @invoice5.id, item_id: @item4.id, quantity: 1, unit_price: 1, status: 1)
    @ii7 = InvoiceItem.create!(invoice_id: @invoice6.id, item_id: @item7.id, quantity: 1, unit_price: 3, status: 1)
    @ii8 = InvoiceItem.create!(invoice_id: @invoice7.id, item_id: @item8.id, quantity: 1, unit_price: 5, status: 1)
    @ii9 = InvoiceItem.create!(invoice_id: @invoice7.id, item_id: @item4.id, quantity: 1, unit_price: 1, status: 1)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice1.id)
    @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice2.id)
    @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice3.id)
    @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice4.id)
    @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice5.id)
    @transaction6 = Transaction.create!(credit_card_number: 879799, result: 0, invoice_id: @invoice6.id)
    @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice7.id)

    visit merchant_items_path(@merchant1)
  end

  it 'can see a list of all the names of my items and not items for other merchants' do
    expect(page).to have_content(@item1.name)
    expect(page).to have_content(@item2.name)
    expect(page).to have_content(@item3.name)
    expect(page).to have_content(@item4.name)

    expect(page).to have_no_content(@item5.name)
    expect(page).to have_no_content(@item6.name)
  end

  it "has links to each item's show pages" do
    expect(page).to have_link(@item1.name)
    expect(page).to have_link(@item2.name)
    expect(page).to have_link(@item3.name)
    expect(page).to have_link(@item4.name)

    within '#enabled-items' do
      click_link @item1.name

      expect(current_path).to eq("/merchant/#{@merchant1.id}/items/#{@item1.id}")
    end
  end

  it 'can make a button to disable items' do
    within "#item-#{@item1.id}" do
      click_button "Disable"

      item = Item.find(@item1.id)
      expect(item.status).to eq('disabled')
    end

    within "#item-#{@item2.id}" do
      click_button 'Enable'

      item = Item.find(@item2.id)
      expect(item.status).to eq('enabled')
    end

    within "#item-#{@item3.id}" do
      click_button 'Enable'

      item = Item.find(@item3.id)
      expect(item.status).to eq('enabled')
    end
  end

  it 'has a section for disabled items' do
    within '#disabled-items' do
      expect(page).to have_content(@item3.name)
      expect(page).to have_content(@item2.name)
      expect(page).to_not have_content(@item1.name)
    end
  end

  it 'has a section for enabled items' do
    within '#enabled-items' do
      expect(page).to_not have_content(@item2.name)
      expect(page).to_not have_content(@item3.name)
      expect(page).to have_content(@item1.name)
    end
  end

  it 'has a link to create a new item' do
    click_link 'Create New Item'

    expect(current_path).to eq(new_merchant_item_path(@merchant1))

    fill_in 'Name', with: 'Bar Shampoo'
    fill_in 'Description', with: 'Eco friendly shampoo'
    fill_in 'Unit price', with: '15'
    click_button 'Submit'

    expect(current_path).to eq(merchant_items_path(@merchant1))

    within '#disabled-items' do
      expect(page).to have_content('Bar Shampoo')
    end
  end

  it 'shows the top 5 most popular items by total revenue' do
    within '#top-items' do
      expect(@item1.name).to appear_before(@item2.name)
      expect(@item2.name).to appear_before(@item3.name)
      expect(@item3.name).to appear_before(@item8.name)
      expect(@item8.name).to appear_before(@item4.name)

      expect(page).to have_no_content(@item7.name)
    end
  end

  it 'links the top 5 to the item show page' do
    within '#top-items' do
      expect(page).to have_link(@item1.name)
      expect(page).to have_link(@item2.name)
      expect(page).to have_link(@item3.name)
      expect(page).to have_link(@item4.name)
      expect(page).to have_link(@item8.name)

      click_link @item1.name.to_s

      expect(current_path).to eq(merchant_item_path(@merchant1, @item1))
    end
  end

  it 'shows the total revenue next to the item' do
    within '#top-items' do
      expect(page).to have_content("#{@merchant1.top_5_items[0].total_revenue}")
      expect(page).to have_content("#{@merchant1.top_5_items[1].total_revenue}")
      expect(page).to have_content("#{@merchant1.top_5_items[2].total_revenue}")
      expect(page).to have_content("#{@merchant1.top_5_items[3].total_revenue}")
      expect(page).to have_content("#{@merchant1.top_5_items[4].total_revenue}")
    end
  end

  it 'shows the best day next to the item' do
    within '#top-items' do
      expect(page).to have_content("Top selling date for #{@item1.name} was #{@item1.best_day}")
      expect(page).to have_content("Top selling date for #{@item2.name} was #{@item2.best_day}")
      expect(page).to have_content("Top selling date for #{@item3.name} was #{@item3.best_day}")
      expect(page).to have_content("Top selling date for #{@item4.name} was #{@item4.best_day}")
      expect(page).to have_content("Top selling date for #{@item8.name} was #{@item8.best_day}")
    end
  end
end
