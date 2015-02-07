require 'rails_helper'

describe "Beer" do
  include OwnTestHelper

  let!(:user) { FactoryGirl.create :user }
  let!(:brewery) { FactoryGirl.create :brewery, name:"Foobrewery" }
  #let!(:style) { "Lager" }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "is created when valid name is given" do
    visit new_beer_path
    fill_in('beer[name]', with:"Foobeer")
    expect{
      click_button('Create Beer')
    }.to change{Beer.count}.by(1)
    expect(page).to have_content 'Foobeer'
  end

  it "is not created with empty name" do
    visit new_beer_path
    fill_in('beer[name]', with:'')
    expect{
      click_button('Create Beer')
    }.to change{Beer.count}.by(0)
    expect(page).to have_content "Name can't be blank"

  end

end