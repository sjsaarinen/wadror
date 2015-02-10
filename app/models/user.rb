class User < ActiveRecord::Base
  include RatingAverage

  has_secure_password

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  validates :username, uniqueness: true,
                       length: { in: 3..15 }

  validates :password, length: { minimum: 4 }

  validates :password, format: { with: /\d.*[A-Z]|[A-Z].*\d/,  message: "has to contain one number and one upper case letter" }

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?
    stylegroup = ratings.group_by{ |r| r.beer.send(:style)}
    stylegroup.each_pair{ |a,b| stylegroup[a] = b.sum(&:score) / b.size.to_f }
    stylegroup.sort_by{ |a| a}.last[0]
  end

  def favorite_brewery
    return nil if ratings.empty?
    brewerygroup = ratings.group_by{ |r| r.beer.send(:brewery)}
    brewerygroup.each_pair{ |a,b| brewerygroup[a] = b.sum(&:score) / b.size.to_f }
    brewerygroup.sort_by{ |a| a}.last[0]
  end

end
