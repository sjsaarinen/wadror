module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    average = ratings.map(&:score).sum.to_f/ratings.count
    if average.nan?
      nil
    else
      average
    end
  end
end