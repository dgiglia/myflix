require "spec_helper"

describe User do
  it { is_expected.to have_many(:reviews).order("created_at DESC") }
  it { is_expected.to have_many(:queue_items).order("position") }
  it { is_expected.to have_many(:leading_relationships).class_name("Relationship").with_foreign_key("leader_id") }
  it { is_expected.to have_many(:following_relationships).class_name("Relationship").with_foreign_key("follower_id") }
  it { is_expected.to have_many(:payments) }
  it { is_expected.to have_secure_password }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:email) }
  
  it_behaves_like "tokenable" do
    let(:object) {Fabricate(:user)}
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
  
  describe "#follow" do
    let(:user) {Fabricate(:user)}
    
    it "follows another user" do
      holly = Fabricate(:user)
      holly.follow(user)
      expect(holly.follows?(user)).to be true
    end
    
    it "does not follow oneself" do
      holly = Fabricate(:user)
      holly.follow(holly)
      expect(holly.follows?(holly)).to be false
    end
  end
  
  describe "#deactivate!" do
    it "deactivates an active user" do
      holly = Fabricate(:user, active: true)
      holly.deactivate!
      expect(holly.reload).not_to be_active
    end
  end
end