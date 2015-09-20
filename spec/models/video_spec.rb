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
  
  it "does not save video without title" do
    Video.create(description: "super funny show")
    expect(Video.count).to eq(0)
  end
  
  it "does not save video without description" do
    Video.create(title: "That 70s Show")
    expect(Video.count).to eq(0)
  end
  
  it "does not save video with duplicate title" do
    Video.create(title: "Mork and Mindy", description: "Robin Williams is an alien!")
    Video.create(title: "Mork and Mindy", description: "Classic comedy")
    expect(Video.count).to eq(1)
  end
end