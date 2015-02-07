require 'rails_helper'

describe User do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    expect(user.username).to eq("Pekka")

  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do

    let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do

      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "is not saved" do

    it "with password that is too short" do
      user = User.create username:"Pekka", password:"S1", password_confirmation:"S1"
      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end

    it "with password that consist only characters" do
      user = User.create username:"Pekka", password:"Secret", password_confirmation:"Secret"
      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end
  end

  describe "favorite beer" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      user.should respond_to :favorite_beer
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryGirl.create(:beer)
      rating = FactoryGirl.create(:rating, beer:beer, user:user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_ratings(10, 20, 15, 7, 9, user, style:"Lager")
      best = create_beer_with_rating(25, user, style:"Lager")

      expect(user.favorite_beer).to eq(best)

    end
  end

  describe "favorite style" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determing it" do
      user.should respond_to :favorite_style
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is, if there is only one rated beer, the style of that beer" do
      create_beer_with_rating(25, user, style:"Ale")

      expect(user.favorite_style).to eq("Ale")
    end

    it "is the style with highest average rating if several rated" do
      create_beers_with_ratings(10, 2, 5, 7, 9, user, style:"Lager")
      create_beers_with_ratings(10, 12, 15, 17, 19, user, style:"Pale Ale")

      expect(user.favorite_style).to eq("Pale Ale")

    end

  end

  describe "favorite brewery" do

    let(:user){FactoryGirl.create(:user) }

    it "has method for determing it" do
      user.should respond_to :favorite_brewery
    end

    it "without any beers rated does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is, if there is only one rated beer, the brewery of that beer" do
      brewery = FactoryGirl.create(:brewery)
      beer = FactoryGirl.create(:beer, brewery:brewery)
      FactoryGirl.create(:rating, score:10, beer:beer, user:user)

      expect(user.favorite_brewery).to eq(brewery)
    end

    it "is the brewery with highest average rating if several rated" do
      brewery1= FactoryGirl.create(:brewery, name:"brew1")
      brewery2= FactoryGirl.create(:brewery, name:"brew2")
      brewery3= FactoryGirl.create(:brewery, name:"brew3")
      create_beers_with_ratings(10, 2, 5, 7, 9, user, brewery:brewery1)
      create_beers_with_ratings(10, 12, 15, user, brewery:brewery2)
      create_beers_with_ratings(20, 22, 25, 27, 29, user, brewery:brewery3)

      expect(user.favorite_brewery).to eq(brewery3)

    end

  end

end

def create_beer_with_rating(score, user, options)
  beer = FactoryGirl.create(:beer, options)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_beers_with_ratings(*scores, user, options)
  scores.each do |score|
    create_beer_with_rating(score, user, options)
  end
end


