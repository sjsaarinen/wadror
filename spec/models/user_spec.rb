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

    let(:user){ User.create username:"Pekka", password:"Secret1", password_confirmation:"Secret1" }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do

      rating = Rating.new score:10
      rating2 = Rating.new score:20

      user.ratings << rating
      user.ratings << rating2

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
end