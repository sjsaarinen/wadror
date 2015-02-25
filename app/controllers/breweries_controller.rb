class BreweriesController < ApplicationController
  before_action :set_brewery, only: [:show, :edit, :update, :destroy]
  before_action :ensure_that_signed_in, except: [:index, :show, :list, :nglist]
  before_action :ensure_that_is_admin, only: [:destroy]

  # GET /breweries
  # GET /breweries.json
  def index
    @breweries = Brewery.all
    @active_breweries = Brewery.active
    @retired_breweries = Brewery.retired

    order = params[:order] || 'name'

    order_direction = case session[:last_brewery_order]
                        when nil then 1
                        when -1 then 1
                        when 1 then -1
                      end

    session[:last_brewery_order] = order_direction

    if order_direction == 1
      @active_breweries = case order
                            when 'name' then @active_breweries.sort_by{ |b| b.name }
                            when 'year' then @active_breweries.sort_by{ |b| b.year }
                          end
      @retired_breweries = case order
                             when 'name' then @retired_breweries.sort_by{ |b| b.name }
                             when 'year' then @retired_breweries.sort_by{ |b| b.year }
                           end

    else
      @active_breweries = case order
                            when 'name' then @active_breweries.sort_by{ |b| b.name }.reverse!
                            when 'year' then @active_breweries.sort_by{ |b| b.year }.reverse!
                          end
      @retired_breweries = case order
                             when 'name' then @retired_breweries.sort_by{ |b| b.name }.reverse!
                             when 'year' then @retired_breweries.sort_by{ |b| b.year }.reverse!
                           end
    end

  end

  # GET /breweries/1
  # GET /breweries/1.json
  def show
  end

  # GET /breweries/new
  def new
    @brewery = Brewery.new
  end

  # GET /breweries/1/edit
  def edit
  end

  # POST /breweries
  # POST /breweries.json
  def create
    @brewery = Brewery.new(brewery_params)

    respond_to do |format|
      if @brewery.save
        format.html { redirect_to @brewery, notice: 'Brewery was successfully created.' }
        format.json { render :show, status: :created, location: @brewery }
      else
        format.html { render :new }
        format.json { render json: @brewery.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /breweries/1
  # PATCH/PUT /breweries/1.json
  def update
    respond_to do |format|
      if @brewery.update(brewery_params)
        format.html { redirect_to @brewery, notice: 'Brewery was successfully updated.' }
        format.json { render :show, status: :ok, location: @brewery }
      else
        format.html { render :edit }
        format.json { render json: @brewery.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /breweries/1
  # DELETE /breweries/1.json
  def destroy
    @brewery.destroy
    respond_to do |format|
      format.html { redirect_to breweries_url, notice: 'Brewery was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def toggle_activity
    brewery = Brewery.find(params[:id])
    brewery.update_attribute :active, (not brewery.active)

    new_status = brewery.active? ? "active" : "retired"

    redirect_to :back, notice:"brewery activity status changed to #{new_status}"
  end

  def list
  end

  def nglist
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_brewery
    @brewery = Brewery.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def brewery_params
    params.require(:brewery).permit(:name, :year, :active)
  end
end
