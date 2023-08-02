class Merchants::DashboardController < ApplicationController
    def index
        @merchant = Merchant.find(params[:merchant_id])
        @random_image = UnsplashService.new.random_photo
    end
end