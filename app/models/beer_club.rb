class BeerClub < ActiveRecord::Base
  has_many :memberships
  has_many :members, -> { uniq }, through: :memberships, source: :user
end
