require 'spec_helper'

describe Admin::VideosController do
  it {is_expected.to use_before_action(:require_user)}
  
  describe "GET new" do
    it "sets @video to new video" do
      set_current_admin
      get :new
      expect(assigns(:video)).to be_a_new Video
    end
    
    it "sets flash error for regular user" do
      set_current_user
      get :new
      expect(flash['danger']).to be_present
    end
    
    it_behaves_like "require sign in" do
      let(:action) {get :new}
    end
    
    it_behaves_like "require admin" do
      let(:action) {get :new}
    end
  end
  
  describe "POST create" do    
    it_behaves_like "require sign in" do
      let(:action) {post :create}
    end
    
    it_behaves_like "require admin" do
      let(:action) {post :create}
    end
    
    context "with valid input" do
      let(:category) {Fabricate(:category)}
      before do
        set_current_admin
        post :create, video: {title: "Foliage", category_id: category.id, description: "leaves"}
      end
      
      it "creates a video" do        
        expect(category.videos.count).to eq(1)
      end
      
      it "redirects to add new video page" do
        expect(response).to redirect_to new_admin_video_path
      end
      
      it {is_expected.to set_flash['success']}
    end
    
    context "with invalid input" do
      let(:category) {Fabricate(:category)}
      before do
        set_current_admin
        post :create, video: {title: "Foliage", category_id: category.id}
      end
      
      it "does not create a video" do
        expect(category.videos.count).to eq(0)
      end
      
      it "renders the new template" do
        expect(response).to render_template :new
      end
      
      it "sets @video variable" do
        expect(assigns(:video)).to be_present
      end
      
      it {is_expected.to set_flash.now['danger']}
    end
  end
end