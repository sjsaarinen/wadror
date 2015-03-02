class RatingsController < ApplicationController
  def index
    return if fragment_exist? 'ratings_cache'

    @top_beers = Beer.top(3)
    @top_breweries = Brewery.top(3)
    @top_styles = Style.top(3)
    @top_raters = User.top_raters(3)
    @recent_ratings = Rating.recent
    @ratings = Rating.all

    #Rails.cache.write('beer top 3', Beer.top(3)) unless fragment_exist? 'ratings_cache'
    #@top_beers = Rails.cache.read 'beer top 3'
    #Rails.cache.write('brewery top 3', Brewery.top(3)) unless fragment_exist? 'ratings_cache'
    #@top_breweries = Rails.cache.read 'brewery top 3'
    #Rails.cache.write('style top 3', Style.top(3)) unless fragment_exist? 'ratings_cache'
    #@top_styles = Rails.cache.read 'style top 3'
    #Rails.cache.write('rater top 3', User.top_raters(3)) unless fragment_exist? 'ratings_cache'
    #@top_raters = Rails.cache.read 'rater top 3'
    #Rails.cache.write('recent ratings', Rating.recent) unless fragment_exist? 'ratings_cache'
    #@recent_ratings = Rails.cache.read 'recent ratings'
    #Rails.cache.write('all ratings', Rating.all) unless fragment_exist? 'ratings_cache'
    #@ratings = Rails.cache.read 'all ratings'
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)

    if current_user.nil?
      redirect_to signin_path, notice:'you should be signed in'
    elsif @rating.save
      current_user.ratings << @rating  ## virheen aiheuttanut rivi
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to :back
  end

end