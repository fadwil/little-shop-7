class Merchants::ItemsController < ApplicationController

  def index
      @merchant = Merchant.find(params[:merchant_id])
      @items = Item.where('merchant_id = ?', params[:merchant_id])
  end

  def update
    # binding.pry;
    @merchant = Merchant.find(params[:merchant_id])
    @item = Item.find(params[:id])
    @item.update(item_params)
      redirect_to merchant_items_path(@merchant), notice: 'Item status updated successfully.'
  end

  def edit
    @item = Item.find(params[:id])
    @merchant = Merchant.find(@item.merchant_id)
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    # binding.pry;
  end


  def create
    @merchant = Merchant.find(params[:merchant_id])
    @item = Item.create(item_params)
    if @item.save
        redirect_to merchant_items_path(@merchant)
    else
        redirect_to new_merchant_item_path
    end
  end

  def show
      @item = Item.find(params[:id])
  end

  private


  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id, :status)
  end

  def item_status_params
    params.require(:items).permit(:status)
  end


end
