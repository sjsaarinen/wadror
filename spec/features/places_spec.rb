require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
                                 [ Place.new( name:"Oljenkorsi", id: 1 ) ]
                             )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if several are returned by the API, all of them are shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("helsinki").and_return(
                                 [ Place.new( name:"Kaisla", id: 1 ),
                                   Place.new( name:"Brew Dog", id: 2 ),
                                   Place.new( name:"Teerenpeli", id: 3 )]
                             )
    visit places_path
    fill_in('city', with: 'helsinki')
    click_button "Search"

    expect(page).to have_content "Kaisla"
    expect(page).to have_content "Brew Dog"
    expect(page).to have_content "Teerenpeli"

  end

  it "if none is returned by the API, notice is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("citywithnobeer").and_return([])

    visit places_path
    fill_in('city', with: 'citywithnobeer')
    click_button "Search"

    expect(page).to have_content "No locations in citywithnobeer"

  end
end