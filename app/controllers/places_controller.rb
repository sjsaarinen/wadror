class PlacesController < ApplicationController

  before_action :set_place, only: [:show]

  def index
  end

  def show
    unless @place
      redirect_to places_path, notice: "Place not found"
    else
      render :show
    end
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      #session[:last_place] = @places
      render :index
    end
  end

  def set_place
    @place = BeermappingApi.place(params[:id])
    if @place.city.nil?
      @place = nil
    end
  end
end