class BeerClub < ActiveRecord::Base
  has_many :memberships
  has_many :members, through: :memberships, source: :user

  def confirmed_members
    memberships.confirmed.collect{|x| x.user}
  end

  def is_member?(user)
    confirmed_members.include? user
  end
end
