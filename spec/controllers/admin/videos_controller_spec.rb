require 'spec_helper'

describe Admin::VideosController do
  it {is_expected.to use_before_action(:require_user)}
  
  describe "GET new" do
    before {set_current_user}
    it "sets @video to new video" do
      set_current_admin
      get :new
      expect(assigns(:video)).to be_a_new Video
    end
    
    it "redirects regular user to home path" do
      get :new
      expect(response).to redirect_to home_path
    end
    
    it "sets flash error for regular user" do
      get :new
      expect(flash['danger']).to be_present
    end
    
    it_behaves_like "require sign in" do
      let(:action) {get :new}
    end
  end
  
end