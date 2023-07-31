class Merchants::ItemsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @item = Item.find(params[:id])
    @item.update(item_params)
      redirect_to merchant_items_path(@merchant), notice: 'Item status updated successfully.'
  end

  def show

  end

  private

  def item_params
    params.require(:item).permit(:status)
  end
end