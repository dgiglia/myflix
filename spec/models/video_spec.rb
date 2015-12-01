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
      expect(video.average_rating).to eq(2.7)
    end
  end
  
  describe ".search", :elasticsearch do
    let(:refresh_index) do
      Video.import
      Video.__elasticsearch__.refresh_index!
    end

    context "with title" do
      it "returns no results when there's no match" do
        Fabricate(:video, title: "Futurama")
        refresh_index

        expect(Video.search("whatever").records.to_a).to eq []
      end

      it "returns an empty array when there's no search term" do
        futurama = Fabricate(:video)
        south_park = Fabricate(:video)
        refresh_index

        expect(Video.search("").records.to_a).to eq []
      end

      it "returns an array of 1 video for title case insensitve match" do
        futurama = Fabricate(:video, title: "Futurama")
        south_park = Fabricate(:video, title: "South Park")
        refresh_index

        expect(Video.search("futurama").records.to_a).to eq [futurama]
      end

      it "returns an array of many videos for title match" do
        star_trek = Fabricate(:video, title: "Star Trek")
        star_wars = Fabricate(:video, title: "Star Wars")
        refresh_index

        expect(Video.search("star").records.to_a).to match_array [star_trek, star_wars]
      end
    end
    
    context "with title and description" do
      it "returns an array of many videos based for title and description match" do
        star_wars = Fabricate(:video, title: "Star Wars")
        about_sun = Fabricate(:video, description: "sun is a star")
        refresh_index

        expect(Video.search("star").records.to_a).to match_array [star_wars, about_sun]
      end
    end

    context "multiple words must match" do
      it "returns an array of videos where 2 words match title" do
        star_wars_1 = Fabricate(:video, title: "Star Wars: Episode 1")
        star_wars_2 = Fabricate(:video, title: "Star Wars: Episode 2")
        bride_wars = Fabricate(:video, title: "Bride Wars")
        star_trek = Fabricate(:video, title: "Star Trek")
        refresh_index

        expect(Video.search("Star Wars").records.to_a).to match_array [star_wars_1, star_wars_2]
      end
    end
    
    context "with title, description and reviews" do
      it 'returns an an empty array for no match with reviews option' do
        star_wars = Fabricate(:video, title: "Star Wars")
        batman    = Fabricate(:video, title: "Batman")
        batman_review = Fabricate(:review, video: batman, comment: "such a star movie!")
        refresh_index

        expect(Video.search("no_match", reviews: true).records.to_a).to eq([])
      end

      it 'returns an array of many videos with relevance title > description > review' do
        star_wars = Fabricate(:video, title: "Star Wars")
        about_sun = Fabricate(:video, description: "the sun is a star!")
        batman    = Fabricate(:video, title: "Batman")
        batman_review = Fabricate(:review, video: batman, comment: "such a star movie!")
        refresh_index

        expect(Video.search("star", reviews: true).records.to_a).to eq([star_wars, about_sun, batman])
      end
    end    
  end  
end