require 'spec_helper'

describe ReviewsController do
  it {is_expected.to use_before_action(:require_user)}
  
  describe "POST create" do
    let(:video) {Fabricate(:video)}
    
    context "with authenticated user" do
      let(:new_user) {Fabricate(:user)}
      before {session[:user_id] = new_user.id}
      
      context "with valid input" do
        before {post :create, review: Fabricate.attributes_for(:review), video_id: video.id}\
          
        it {is_expected.to redirect_to video}
        
        it "creates a review" do
          expect(Review.count).to eq(1)
        end
        
        it "creates review associated with the video" do
          expect(Review.first.video).to eq(video)
        end
        
        it "creates review associated with the user" do
          expect(Review.first.user).to eq(new_user)
        end
        
      end
      
      context "with invalid input" do
        before {post :create, review: {comment: "vgkh"}, video_id: video.id}
        
        it {is_expected.to render_template("videos/show")}
        
        it "does not create a review" do
          expect(Review.count).to eq(0)
        end
        
        it "sets @video" do
          expect(assigns(:video)).to eq(video)
        end
        
        it "sets @reviews" do
          review1 = Fabricate(:review, video: video)
          post :create, review: {comment: "vgkh"}, video_id: video.id
          expect(assigns(:reviews)).to match_array([review1])
        end
      end
    end
    
    context "with unauthenticated user" do
      it "redirects to front page" do
        post :create, review: Fabricate.attributes_for(:review), video_id: video.id
        expect(response).to redirect_to root_path
      end
    end
  end
end