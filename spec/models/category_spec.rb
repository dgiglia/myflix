require "spec_helper"

describe Category do
  it { is_expected.to have_many(:videos) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }
  
  describe "#recent_videos" do
    context "with videos" do
      before do
        @drama = Fabricate(:category, name: "drama")
        @mad_men = Fabricate(:video, title: "Mad Men", category: @drama, created_at: 1.day.ago)
        @mentalist = Fabricate(:video, title: "The Mentalist", category: @drama)
      end

      it "it returns videos in reverse chronical order by created at" do
        expect(@drama.recent_videos).to eq([@mentalist, @mad_men])
      end

      it "returns all videos if less than 6 videos" do
        expect(@drama.recent_videos.count).to eq(2)
      end

      it "returns 6 videos if more than 6 videos" do
        Fabricate(:video, title: "Friends", category: @drama)
        Fabricate(:video, title: "Gilmore Girls", category: @drama)
        Fabricate(:video, title: "The Simpsons", category: @drama)
        Fabricate(:video, title: "Futurama", category: @drama)
        Fabricate(:video, title: "Star Trek", category: @drama)
        expect(@drama.recent_videos.count).to eq(6)
      end

      it "returns most recent 6 videos" do
        Fabricate(:video, title: "Friends", category: @drama)
        Fabricate(:video, title: "Gilmore Girls", category: @drama)
        Fabricate(:video, title: "The Simpsons", category: @drama)
        Fabricate(:video, title: "Futurama", category: @drama)
        Fabricate(:video, title: "Star Trek", category: @drama)
        expect(@drama.recent_videos).not_to include(@mad_men)
      end
    end
    context "without videos" do
      it "returns empty array if no videos" do
        drama = Fabricate(:category, name: "drama")
        expect(drama.recent_videos).to eq([])
      end
    end
  end
end