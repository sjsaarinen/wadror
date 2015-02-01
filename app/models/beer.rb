class Beer < ActiveRecord::Base
  include RatingAverage
  belongs_to :brewery
  has_many :ratings, dependent: :destroy
  has_many :raters, ->  {uniq}, through: :ratings, source: :user

  validates :name, presence: true

  def to_s
    "#{brewery.name}: #{name}"
  end

  def average
    return 0 if ratings.empty?
    ratings.map{ |r| r.score }.sum / ratings.count.to_f
  end

end
