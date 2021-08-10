class Admin::MerchantsController < ApplicationController
  before_action :fetch_current_merchant, only: [:show, :edit]

  def index
    @merchants = Merchant.all
  end

  def show
  end

  def new
    @merchant = Merchant.new
  end

  # TODO: Add dynamic flash messages
  def create
    Merchant.create!(merchant_params)
    flash.notice = 'Success! A new merchant was created.'
    redirect_to admin_merchants_path
  end

  def edit
  end

  # TODO: Add dynamic flash messages
  def update
    merchant = Merchant.find(params[:id])

    if merchant.update(merchant_params)
      flash.notice = 'Success! The merchant was updated.'
      redirect_to admin_merchant_path(merchant)
    else
      flash.alert = 'Error! All fields must be completed.'
      redirect_to edit_admin_merchant_path(merchant)
    end
  end

  private

  def fetch_current_merchant
    @merchant = Merchant.find(params[:id])
  end

  def merchant_params
    params.require(:merchant).permit(:name)
  end
end
