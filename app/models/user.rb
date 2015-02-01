class User < ActiveRecord::Base
  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true,
                       length: {minimum: 3, maximum: 15 }
  validates :password, length: {minimum: 4},
                       format: {with: /(\S*[A-Z]+\S*\d+\S*)|(\S*\d+\S*[A-Z]+\S*)/, message: "must contain at least one capital letter and one number"}

  has_many :memberships
  has_many :ratings
  has_many :beer_clubs, through: :memberships
end