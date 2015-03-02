class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :beer_club

  scope :confirmed, -> { where confirmed: true }
  scope :not_confirmed, -> { where confirmed:[nil,false] }

end
