class ItemsController < ApplicationController
  before_action :fetch_current_item, only: [:show, :edit, :update]
  before_action :fetch_current_merchant, except: :destroy

  def index
    @enabled_items = @merchant.items.where(status: 1)
    @disabled_items = @merchant.items.where(status: 0)
  end

  def show
  end

  def edit
  end

  # TODO: Add dynamic flash messages
  def update
    if @item.update(item_params)
      flash.notice = 'Success! The item was updated.'
      redirect_to merchant_item_path(@merchant, @item)
    else
      flash.notice = 'Error! All fields must be completed.'
      redirect_to edit_merchant_item_path(@merchant, @item)
    end
  end

  def new
    @item = Item.new
  end

  def create
    @merchant.items.create!(item_params)
    flash.notice = 'Success! A new item was created.'
    redirect_to merchant_items_path(@merchant)
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price)
  end

  def fetch_current_item
    @item = Item.find(params[:id])
  end

  def fetch_current_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end
