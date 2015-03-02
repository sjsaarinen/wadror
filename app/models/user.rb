class User < ActiveRecord::Base
  include RatingAverage
  extend Top
  require 'securerandom'

  has_secure_password

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  validates :username, uniqueness: true,
                       length: { in: 3..25 }

  validates :password, length: { minimum: 4 }

  validates :password, format: { with: /\d.*[A-Z]|[A-Z].*\d/,  message: "has to contain one number and one upper case letter" }

  scope :active, -> { where disabled:[nil,false] }
  scope :frozen, -> { where disabled: true}

  def self.create_with_omniauth(auth)
    create! do |user|
      user.username = auth["info"]["name"]
      #user.password = 'A' + SecureRandom.hex + '0'
      user.password = SecureRandom.urlsafe_base64(32)
    end
  end

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_brewery
    favorite :brewery
  end

  def favorite_style
    favorite :style
  end

  def favorite(category)
    return nil if ratings.empty?
    category_ratings = rated(category).inject([]) do |set, item|
      set << {
          item: item,
          rating: rating_of(category, item) }
    end
    category_ratings.sort_by { |item| item[:rating] }.last[:item]
  end

  def rated(category)
    ratings.map{ |r| r.beer.send(category)}.uniq
  end

  def rating_of(category, item)
    ratings_of_item = ratings.select do |r|
      r.beer.send(category) == item
    end
    ratings_of_item.map(&:score).sum / ratings_of_item.count
  end

  def self.top_raters(n)
    user_ratings_count_desc_order = User.all.sort_by { |u| -(u.ratings.count) }
    user_ratings_count_desc_order.first(n)
  end
end
