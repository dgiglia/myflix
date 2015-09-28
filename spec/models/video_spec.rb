require "spec_helper"

describe Video do
  it { is_expected.to belong_to(:category) }
  it { is_expected.to have_many(:queue_items) }
  it { is_expected.to have_many(:reviews).order("created_at DESC") }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_uniqueness_of(:title) }
  
  describe "search_by_title" do
    it "returns an empty array if no match" do
      mad_men = Video.create(title: "Mad Men", description: "period piece on advertising industry")
      mentalist = Video.create(title: "The Mentalist", description: "math and logic in solving crime")
      expect(Video.search_by_title("california")).to eq([])
    end
    
    it "returns an array of one video for exact match" do
      mad_men = Video.create(title: "Mad Men", description: "period piece on advertising industry")
      mentalist = Video.create(title: "The Mentalist", description: "math and logic in solving crime")
      expect(Video.search_by_title("Mad Men")).to eq([mad_men])
    end
    
    it "returns an array of one video for a partial match" do
      mad_men = Video.create(title: "Mad Men", description: "period piece on advertising industry")
      mentalist = Video.create(title: "The Mentalist", description: "math and logic in solving crime")
      expect(Video.search_by_title("Mad")).to eq([mad_men])
    end
    
    it "returns an array of all matches ordered by title" do
      mad_men = Video.create(title: "Mad Men", description: "period piece on advertising industry")
      mentalist = Video.create(title: "The Mentalist", description: "math and logic in solving crime")
      expect(Video.search_by_title("Men")).to eq([mad_men, mentalist])
    end
    
    it "returns an empty array if search term is blank" do
      mad_men = Video.create(title: "Mad Men", description: "period piece on advertising industry")
      mentalist = Video.create(title: "The Mentalist", description: "math and logic in solving crime")
      expect(Video.search_by_title("")).to eq([])
    end
    
    it "returns an array of all matches with search term is case insensitive" do
      mad_men = Video.create(title: "Mad Men", description: "period piece on advertising industry")
      mentalist = Video.create(title: "The Mentalist", description: "math and logic in solving crime")
      expect(Video.search_by_title("men")).to eq([mad_men, mentalist])
    end
  end
  
  describe "#average_rating" do
    it "returns 0 if no reviews" do
      video = Fabricate(:video)
      expect(video.average_rating).to eq(0)
    end
    
    it "returns an average rating to one decimal place if reviews" do
      video = Fabricate(:video)
      review1 = Fabricate(:review, video: video, rating: 5)
      review2 = Fabricate(:review, video: video, rating: 1)
      review2 = Fabricate(:review, video: video, rating: 2)
      average = (5 + 1 + 2) / 3
      expect(video.average_rating).to eq(average.round(1))
    end
  end
end