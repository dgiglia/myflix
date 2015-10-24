require "spec_helper"

describe User do
  it { is_expected.to have_many(:reviews).order("created_at DESC") }
  it { is_expected.to have_many(:queue_items).order("position") }
  it { is_expected.to have_secure_password }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:email) }
  
  describe "#queued_video?" do
    it "return true when the user has already queued the video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      Fabricate(:queue_item, user: user, video: video)
      expect(user.queued_video?(video)).to be_true
    end
    
    it "returns false when the user has not queued the video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      expect(user.queued_video?(video)).to be_false
    end
  end
end