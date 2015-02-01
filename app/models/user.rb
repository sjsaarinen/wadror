class User < ActiveRecord::Base
  include RatingAverage

  validates :username, uniqueness: true,
                       length: {minimum: 3, maximum: 15 }

  has_many :memberships
  has_many :ratings
  has_many :beer_clubs, through: :memberships
end