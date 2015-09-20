require "spec_helper"

describe Category do
  it "saves itself" do
    category = Category.new(name: "Drama")
    category.save
    expect(Category.first).to eq(category)
  end
  
  it "has many videos" do
    drama = Category.create(name: "Drama")
    turn = Video.create(title: "Turn", description: "Revolutionary war era drama", category: drama)
    fosters = Video.create(title: "The Fosters", description: "Modern day foster family", category: drama)
    expect(drama.videos).to eq([fosters, turn])
  end
end