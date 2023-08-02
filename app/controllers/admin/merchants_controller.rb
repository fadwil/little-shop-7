class Admin::MerchantsController < ApplicationController

  def index
    @merchants = Merchant.all
    @enabled_merchants = Merchant.enabled
    @disabled_merchants = Merchant.disabled
    @top_merchants_with_dates = Merchant.top_merchants_by_revenue.map do |merchant|
      {
        merchant: merchant,
        top_selling_date: merchant.top_selling_date
      }
    end
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  def edit
    @merchant = Merchant.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:id])
    if merchant.update(merchant_params)
      flash[:notice] = "Merchant updated successfully"
      redirect_to "/admin/merchants/#{merchant.id}"
    else
      render :edit
    end
  end

  def new
    @merchant = Merchant.new
  end

  def create
    @merchant = Merchant.new(merchant_params)
    @merchant.status = 'disabled'

    if @merchant.save
      redirect_to "/admin/merchants", notice: "Merchant created successfully."
    else
      render :new
    end
  end

  def enable_status
    @merchant = Merchant.find(params[:id])
    @merchant.update(status: :enabled)
    redirect_to "/admin/merchants", notice: "Merchant status updated"
  end

  def disable_status
    @merchant = Merchant.find(params[:id])
    @merchant.update(status: :disabled)
    redirect_to "/admin/merchants", notice: "Merchant status updated"
  end

  private

  def merchant_params
    params.require(:merchant).permit(:name)
  end
end