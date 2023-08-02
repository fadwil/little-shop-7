class ApplicationController < ActionController::Base
    before_action :logo
    
    def logo
        @logo = UnsplashService.new.get_logo
    end

end
