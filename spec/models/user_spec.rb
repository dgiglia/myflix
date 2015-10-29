require "spec_helper"

describe User do
  it { is_expected.to have_many(:reviews).order("created_at DESC") }
  it { is_expected.to have_many(:queue_items).order("position") }
  it { is_expected.to have_many(:leading_relationships).class_name("Relationship").with_foreign_key("leader_id") }
  it { is_expected.to have_many(:following_relationships).class_name("Relationship").with_foreign_key("follower_id") }
  it { is_expected.to have_secure_password }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:email) }
  
  it "generates a random token when the user is created" do
    frank = Fabricate(:user)
    expect(frank.token).to be_present
  end
  
  describe "#follows?" do
    let(:frank) {Fabricate(:user)}
    let(:george) {Fabricate(:user)}
    before {Fabricate(:relationship, leader: frank, follower: george)}
    it "returns true if user has following relationship with another_user" do
      expect(george.follows?(frank)).to be true
    end
    
    it "returns false if user does not have a following relationship with another_user" do      
      expect(frank.follows?(george)).to be false
    end
  end
  
  describe "#queued_video?" do
    let(:user) {Fabricate(:user)}
    let(:video) {Fabricate(:video)}
    
    it "return true when the user has already queued the video" do
      Fabricate(:queue_item, user: user, video: video)
      expect(user.queued_video?(video)).to be true
    end
    
    it "returns false when the user has not queued the video" do
      expect(user.queued_video?(video)).to be false
    end
  end
end