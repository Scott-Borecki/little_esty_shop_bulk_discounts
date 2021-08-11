class BulkDiscountsController < ApplicationController
  before_action :fetch_current_bulk_discount, only: [:edit, :show]
  before_action :fetch_current_merchant

  def index
    @upcoming_holidays = HolidayFacade.upcoming_holidays
  end

  def new
    @new_bulk_discount = BulkDiscount.new
  end

  def create
    bulk_discount = @merchant.bulk_discounts.create(bulk_discount_params)
    if bulk_discount.save
      flash.notice = 'Success! A new bulk discount was created.'
      redirect_to merchant_bulk_discounts_path(@merchant)
    else
      flash.alert = "Error! #{error_message(bulk_discount.errors)}."
      redirect_to new_merchant_bulk_discount_path(@merchant)
    end
  end

  def show
  end

  def edit
  end

  def update
    bulk_discount = BulkDiscount.find(params[:id])
    if bulk_discount.update(bulk_discount_params)
      flash.notice = 'Success! The bulk discount was updated.'
      redirect_to merchant_bulk_discount_path(@merchant, bulk_discount)
    else
      flash.alert = "Error! #{error_message(bulk_discount.errors)}."
      redirect_to edit_merchant_bulk_discount_path(@merchant, bulk_discount)
    end
  end

  def destroy
    bulk_discount = BulkDiscount.find(params[:id])
    bulk_discount.destroy!

    flash.notice = 'Success! The bulk discount was deleted.'
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  private

  def fetch_current_bulk_discount
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def fetch_current_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def bulk_discount_params
    params.required(:bulk_discount).permit(:percentage_discount, :quantity_threshold)
  end
end
