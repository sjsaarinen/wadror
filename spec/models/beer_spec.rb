require 'rails_helper'

describe Beer do
  it "with name and style set is saved" do
    beer = Beer.create name:"foobeer", style:"ale"
    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  describe "is not saved" do
    it "without name" do
      beer = Beer.create
      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end

    it "without style" do
      beer = Beer.create name:"foobeer"
      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end
  end

end
