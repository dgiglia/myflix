require 'spec_helper'

describe VideosController do
  describe "GET show" do
    it "sets the @video for authenticated user" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end
    
    it "sets @reviews for authenticated user" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      review1 = Fabricate(:review, video: video)
      review2 = Fabricate(:review, video: video)      
      get :show, id: video.id
      expect(assigns(:reviews)).to match_array([review1, review2])
    end
    
    it "redirects unauthenticated user to front page" do
      video = Fabricate(:video)
      get :show, id: video.id
      expect(response).to redirect_to root_path
    end
  end
  
  describe "GET search" do
    it "sets @results for authenticated user" do
      session[:user_id] = Fabricate(:user).id
      dr_who = Fabricate(:video, title: 'Doctor Who')
      get :search, search_term: 'doc'
      expect(assigns(:results)).to eq([dr_who])
    end
    
    it "redirects unauthenticated user to front page" do
      dr_who = Fabricate(:video, title: 'Doctor Who')
      get :search, search_term: 'doc'
      expect(response).to redirect_to root_path
    end
  end

end