require 'rails_helper'

include OwnTestHelper

describe "User" do
  before :each do
    FactoryGirl.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")
      #save_and_open_page
      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
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

  end

  describe "ratings" do
    let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
    let!(:beer) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
    let!(:user) { FactoryGirl.create(:user, username:"Nikolai") }
    it "are displayed on users page" do
      FactoryGirl.create(:rating, score:20, beer:beer, user:user)
      FactoryGirl.create(:rating, score:18, beer:beer, user:user)
      visit user_path(user)
      expect(page).to have_content "has made 2 ratings"
      expect(page).to have_content "Karhu 20"
      expect(page).to have_content "Karhu 18"
    end

    it "that are not made by user are not displayed on users page" do
      user2 = FactoryGirl.create(:user, username:"Samuel")
      FactoryGirl.create(:rating, score:13, beer:beer, user:user2)
      FactoryGirl.create(:rating, score:11, beer:beer, user:user2)
      visit user_path(user)
      expect(page).to have_content "has made 0 ratings"
      expect(page).not_to have_content "Karhu 13"
      expect(page).not_to have_content "Karhu 11"
    end

  end


end