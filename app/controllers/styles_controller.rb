class StylesController < ApplicationController

  def index
    @styles = Style.all
  end

  def show
    @style = Style.find(params[:id])
  end

  # GET /styles/new
  def new
    @style = Style.new
  end

  # POST /styles
  # POST /styles.json
  def create
    @style = Style.new(style_params)

    respond_to do |format|
      if @style.save
        format.html { redirect_to styles_path, notice: 'Style was successfully created.' }
        format.json { render :show, status: :created, location: @style }
      else
        format.html { render :new }
        format.json { render json: @style.errors, status: :unprocessable_entity }
      end
    end
  end

  def style_params
    params.require(:style).permit(:name, :description)
  end

end