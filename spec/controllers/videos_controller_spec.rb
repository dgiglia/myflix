require 'spec_helper'

describe VideosController do
  it {is_expected.to use_before_action(:require_user)}
  
  describe "GET show" do
    before do
      set_current_user
    end
    let(:video) {Fabricate(:video)}
    
    it "sets the video for authenticated user" do
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end
    
    it "sets @reviews for authenticated user" do
      review1 = Fabricate(:review, video: video)
      review2 = Fabricate(:review, video: video)      
      get :show, id: video.id
      expect(assigns(:reviews)).to match_array([review1, review2])
    end
    
    it_behaves_like "require sign in" do
      let(:action) {get :show, id: video.id}
    end
  end
  
  describe "GET search" do
    before do
      set_current_user
      @dr_who = Fabricate(:video, title: "Doctor Who")
    end
    
    it "sets @results for authenticated user" do
      get :search, search_term: 'doc'
      expect(assigns(:results)).to eq([@dr_who])
    end
    
    it_behaves_like "require sign in" do
      let(:action) {get :search, search_term: 'doc'}
    end
  end

end