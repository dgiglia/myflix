require "spec_helper"

describe Category do
  it { is_expected.to have_many(:videos) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }
  
  describe "#recent_videos" do
    it "it returns videos in reverse chronical order by created at" do
      drama = Category.create(name: "drama")
      mad_men = Video.create(title: "Mad Men", description: "period piece on advertising industry", category: drama, created_at: 1.day.ago)
      mentalist = Video.create(title: "The Mentalist", description: "math and logic in solving crime", category: drama)
      expect(drama.recent_videos).to eq([mentalist, mad_men])
    end
    
    it "returns all videos if less than 6 videos" do
      drama = Category.create(name: "drama")
      mad_men = Video.create(title: "Mad Men", description: "period piece on advertising industry", category: drama, created_at: 1.day.ago)
      mentalist = Video.create(title: "The Mentalist", description: "math and logic in solving crime", category: drama)
      expect(drama.recent_videos.count).to eq(2)
    end
    
    it "returns 6 videos if more than 6 videos" do
      drama = Category.create(name: "drama")
      Video.create(title: "Mad Men", description: "period piece on advertising industry", category: drama)
      Video.create(title: "The Mentalist", description: "math and logic in solving crime", category: drama)
      Video.create(title: "Friends", description: "goofy 90s show", category: drama)
      Video.create(title: "Gilmore Girls", description: "high school drama", category: drama)
      Video.create(title: "The Simpsons", description: "funny cartoon", category: drama)
      Video.create(title: "Futurama", description: "funny futuristic cartoon", category: drama)
      Video.create(title: "Star Trek", description: "math and logic in solving crime", category: drama)
      expect(drama.recent_videos.count).to eq(6)
    end
    
    it "returns most recent 6 videos" do
      drama = Category.create(name: "drama")
      mad_men = Video.create(title: "Mad Men", description: "period piece on advertising industry", category: drama)
      mentalist = Video.create(title: "The Mentalist", description: "math and logic in solving crime", category: drama)
      friends = Video.create(title: "Friends", description: "goofy 90s show", category: drama)
      gilmore = Video.create(title: "Gilmore Girls", description: "high school drama", category: drama)
      simpsons = Video.create(title: "The Simpsons", description: "funny cartoon", category: drama)
      futurama = Video.create(title: "Futurama", description: "funny futuristic cartoon", category: drama)
      star_trek = Video.create(title: "Star Trek", description: "math and logic in solving crime", category: drama, created_at: 1.day.ago)
      expect(drama.recent_videos).not_to include(star_trek)
    end
    
    it "returns empty array if no videos" do
      drama = Category.create(name: "drama")
      expect(drama.recent_videos).to eq([])
    end
  end
end