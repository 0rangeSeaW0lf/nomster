class PlacesController < ApplicationController
    # Authenticate users who whishes to add places
    before_action :authenticate_user!, :only => [:new, :create]
    
    def index
        @places = Place.all.paginate(page: params[:page], per_page: 4)
    end
    
    def new
        @place = Place.new
    end
    
    # Creates place
    def create
        current_user.places.create(place_params)
        redirect_to root_path
    end
    
    def show
        @place = Place.find(params[:id])
    end
    
    def edit
        @place = Place.find(params[:id])
    end
    
    private
    
    def place_params
        params.require(:place).permit(:name, :description, :address)
    end
end

