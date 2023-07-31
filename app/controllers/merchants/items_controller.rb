class Merchants::ItemsController < ApplicationController

    def index
        @merchant = Merchant.find(params[:merchant_id])
        @items = Item.where('merchant_id = ?', params[:merchant_id])
    end

    def show
        @item = Item.find(params[:id])
    end

    def edit
        @item = Item.find(params[:id])
        @merchant = Merchant.find(@item.merchant_id)
    end
    
    def update
        item = Item.find(params[:id])
        if item.update(item_params)
            flash[:notice] = "Item updated successfully"
            redirect_to merchant_item_path(item.id, Merchant.find(params[:merchant_id]))
        else
            render :edit
        end
    end

    def new

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

    private

    def item_params
        params.permit(:name, :description, :unit_price, :merchant_id)
    end
end