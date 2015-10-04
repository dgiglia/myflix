require "spec_helper"

describe Video do
  it { is_expected.to belong_to(:category) }
  it { is_expected.to have_many(:queue_items) }
  it { is_expected.to have_many(:reviews).order("created_at DESC") }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_uniqueness_of(:title) }
  
  describe "search_by_title" do
    let(:mad_men) {Fabricate(:video, title: "Mad Men")}
    let(:mentalist) {Fabricate(:video, title: "The Mentalist")}
    it "returns an empty array if no match" do
      expect(Video.search_by_title("california")).to eq([])
    end
    
    it "returns an array of one video for exact match" do
      expect(Video.search_by_title("Mad Men")).to eq([mad_men])
    end
    
    it "returns an array of one video for a partial match" do
      expect(Video.search_by_title("Mad")).to eq([mad_men])
    end
    
    it "returns an array of all matches ordered by title" do
      expect(Video.search_by_title("Men")).to eq([mad_men, mentalist])
    end
    
    it "returns an empty array if search term is blank" do
      expect(Video.search_by_title("")).to eq([])
    end
    
    it "returns an array of all matches with search term is case insensitive" do
      expect(Video.search_by_title("men")).to eq([mad_men, mentalist])
    end
  end
  
  describe "#average_rating" do
    let(:video) {Fabricate(:video)}
    
    it "returns 0 if no reviews" do
      expect(video.average_rating).to eq(0)
    end
    
    it "returns an average rating to one decimal place if reviews" do
      review1 = Fabricate(:review, video: video, rating: 5)
      review2 = Fabricate(:review, video: video, rating: 1)
      review3 = Fabricate(:review, video: video, rating: 2)
      average = (5 + 1 + 2) / 3
      expect(video.average_rating).to eq(2.7)
    end
  end
end