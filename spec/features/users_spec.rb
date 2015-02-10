require 'rails_helper'
include OwnTestHelper

describe "User" do
  before :each do
    FactoryGirl.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with:'Brian')
    fill_in('user_password', with:'Secret55')
    fill_in('user_password_confirmation', with:'Secret55')

    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end

  describe "favorite" do
    let!(:user) { FactoryGirl.create :user, username:"Samuel" }

    before :each do
      brewery = FactoryGirl.create(:brewery, name:"Koff")
      brewery2 = FactoryGirl.create(:brewery, name:"Hoff")
      beer = FactoryGirl.create(:beer, name:"Karhu", style:"Lager", brewery:brewery)
      beer2 = FactoryGirl.create(:beer, name:"Hassel", style:"Pilsner", brewery:brewery2)
      FactoryGirl.create(:rating, score:15, beer:beer, user:user)
      FactoryGirl.create(:rating, score:20, beer:beer2, user:user)
      FactoryGirl.create(:rating, score:25, beer:beer2, user:user)
    end

    it "brewery is displayed on users page" do
      visit user_path(user)
      expect(page).to have_content "favorite brewery Hoff"
    end

    it "style is displayed on users page" do
      visit user_path(user)
      expect(page).to have_content "favorite style Pilsner"
    end

  end

end