require "spec_helper"

describe Video do
  it "saves itself" do
    video = Video.new(title: "Jericho", description: "American post-apocalyptic action-drama series")
    video.save
    expect(Video.first).to eq(video)
  end
  
  it "belongs to category" do
    comedy = Category.create(name: "Comedy")
    simpsons = Video.create(title: "The Simpsons", description: "Doh!", category: comedy)
    expect(simpsons.category).to eq(comedy)
  end
end