require 'rails_helper'

RSpec.describe "Merchant's Discounts Index Page", type: :feature do
  describe 'When I visit my bulk discounts index' do
    before :each do
      @merchant1 = Merchant.create!(name: "Hair Care")

      @customer_1 = Customer.create!(first_name: "Joey", last_name: "Smith")
      @customer_2 = Customer.create!(first_name: "Cecilia", last_name: "Jones")
      @customer_3 = Customer.create!(first_name: "Mariah", last_name: "Carrey")
      @customer_4 = Customer.create!(first_name: "Leigh Ann", last_name: "Bron")
      @customer_5 = Customer.create!(first_name: "Sylvester", last_name: "Nader")
      @customer_6 = Customer.create!(first_name: "Herber", last_name: "Kuhn")

      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2)
      @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2)
      @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
      @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
      @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
      @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
      @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 1)

      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id)
      @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
      @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
      @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)

      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
      @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
      @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
      @ii_4 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
      @ii_5 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
      @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
      @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)

      @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
      @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_3.id)
      @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_4.id)
      @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_5.id)
      @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_6.id)
      @transaction6 = Transaction.create!(credit_card_number: 879799, result: 1, invoice_id: @invoice_7.id)
      @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_2.id)

      @discount1 = @merchant1.discounts.create!(percent_discount: 10, threshold_quantity: 10)
      @discount2 = @merchant1.discounts.create!(percent_discount: 15, threshold_quantity: 20)
      @discount3 = @merchant1.discounts.create!(percent_discount: 40, threshold_quantity: 30)
      @discount4 = @merchant1.discounts.create!(percent_discount: 70, threshold_quantity: 40)

      visit merchant_discounts_path(@merchant1)
    end

    it "shows discounts with percentage of" do
      within("#discount-list") do
        expect(page).to have_content("Discount: #{@discount1.percent_discount}%", count: 1)
        expect(page).to have_content("Discount: #{@discount2.percent_discount}%", count: 1)
        expect(page).to have_content("Discount: #{@discount3.percent_discount}%", count: 1)
        expect(page).to have_content("Discount: #{@discount4.percent_discount}%", count: 1)
      end
    end

    it "dhows discounts with quantity threshold " do
      within("#discount-list") do
        expect(page).to have_content("- Quantity Threshold: #{@discount1.threshold_quantity}")
        expect(page).to have_content("- Quantity Threshold: #{@discount2.threshold_quantity}")
        expect(page).to have_content("- Quantity Threshold: #{@discount3.threshold_quantity}")
        expect(page).to have_content("- Quantity Threshold: #{@discount4.threshold_quantity}")
      end
    end

    it "links to each discount's show page " do
      within("#discount-list") do
        expect(page).to have_link(href: merchant_discount_path(@merchant1, @discount1), count: 1)
        expect(page).to have_link(href: merchant_discount_path(@merchant1, @discount2), count: 1)
        expect(page).to have_link(href: merchant_discount_path(@merchant1, @discount3), count: 1)
        expect(page).to have_link(href: merchant_discount_path(@merchant1, @discount4), count: 1)
      end
    end

    it "has link to create a new discount" do
      expect(page).to have_link("Add New Discount", href: new_merchant_discount_path(@merchant1))

      click_link("Add New Discount")

      expect(current_path).to eq(new_merchant_discount_path(@merchant1))
    end

    it "hak link next to discount to delete" do
      within("#discount-list") do
        expect(page).to have_button("Delete", id: "delete-#{@discount1.id}", count: 1)
        expect(page).to have_button("Delete", id: "delete-#{@discount2.id}", count: 1)
        expect(page).to have_button("Delete", id: "delete-#{@discount3.id}", count: 1)
        expect(page).to have_button("Delete", id: "delete-#{@discount4.id}", count: 1)
      end
    end
  end
end