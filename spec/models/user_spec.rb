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
      create_beers_with_ratings(10, 20, 15, 7, 9, user)
      best = create_beer_with_rating(25, user)

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
      create_beer_with_rating_and_style(25, "Ale", user)

      expect(user.favorite_style).to eq("Ale")
    end

    it "is the style with highest average rating if several rated" do
      create_beer_with_rating_and_style(24, "Pale Ale", user)
      create_beer_with_rating_and_style(20, "Pale Ale", user)
      create_beer_with_rating_and_style(5, "Lager", user)
      create_beer_with_rating_and_style(10, "Lager", user)

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
      brewery1 = FactoryGirl.create(:brewery, name:"brew1")
      brewery2= FactoryGirl.create(:brewery, name:"brew2")
      brewery3= FactoryGirl.create(:brewery, name:"brew3")
      create_beer_with_rating_and_brewery(20, brewery1, user)
      create_beer_with_rating_and_brewery(22, brewery1, user)
      create_beer_with_rating_and_brewery(19, brewery1, user)
      create_beer_with_rating_and_brewery(19, brewery2, user)
      create_beer_with_rating_and_brewery(12, brewery2, user)
      create_beer_with_rating_and_brewery(5, brewery3, user)


      expect(user.favorite_brewery).to eq(brewery1)

    end

  end

end

def create_beer_with_rating(score, user)
  beer = FactoryGirl.create(:beer)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_beers_with_ratings(*scores, user)
  scores.each do |score|
    create_beer_with_rating(score, user)
  end
end

def create_beer_with_rating_and_style(score, style, user)
  beer = FactoryGirl.create(:beer, style:style)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_beer_with_rating_and_brewery(score, brewery, user)

  beer = FactoryGirl.create(:beer, brewery:brewery)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end
