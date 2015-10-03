require "spec_helper"

describe QueueItem do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:video) }
  it { is_expected.to validate_numericality_of(:position).only_integer }
  
  describe "#video_title" do
    it "returns title of associated video" do
      video = Fabricate(:video, title: "Scuba")
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_title).to eq("Scuba")
    end
  end
  
  describe "#rating" do
    it "returns review rating if there is a review" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = (Fabricate :review, user: user, video: video, rating: 4)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to eq(4)
    end
    
    it "returns nil if there is no review" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to eq(nil)
    end
  end
  
  describe "#rating=" do
    let(:video) {Fabricate(:video)}
    let(:user) {Fabricate(:user)}
    let(:item) {Fabricate(:queue_item, user: user, video: video)}
    
    it "changes the rating if review is present" do
      review = Fabricate(:review, user: user, video: video, rating: 2)
      item.rating = 4
      expect(item.reload.rating).to eq(4)
    end
    
    it "clears rating if review is present" do
      review = Fabricate(:review, user: user, video: video, rating: 2)
      item.rating = nil
      expect(item.reload.rating).to be_nil
    end
    
    it "creates review with rating if review is not present" do
      item.rating = 4
      expect(item.reload.rating).to eq(4)
    end
  end
  
  describe "#category_name" do
    it "returns category name for associated video" do
      category = Fabricate(:category, name: "Junk")
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category_name).to eq("Junk")
    end
  end
  
  describe "#category" do
    it "returns category of the video" do
      category = Fabricate(:category)
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category).to eq(category)
    end
  end
end