require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    it "renders new template for unauthenticated users" do
      get :new
      expect(response).not_to redirect_to home_path
    end
    it "redirects to home page for authenticated users" do
      set_current_user
      get :new
      expect(response).to redirect_to home_path
    end
  end
  
  describe "POST create" do
    let(:jenkins) {Fabricate(:user)}
    
    context "with valid credentials" do
      before {post :create, email: jenkins.email, password: jenkins.password}
      
      it {is_expected.to set_session[:user_id].to(jenkins.id)}      
      it {is_expected.to redirect_to home_path}      
      it {is_expected.to set_flash}
    end
    
    context "with invalid credentials" do
      before {post :create, email: jenkins.email, password: jenkins.password + 'dfhhtdf'}
      
      it {is_expected.to set_session(nil)}      
      it {is_expected.to redirect_to sign_in_path}      
      it {is_expected.to set_flash}
    end
  end
  
  describe "GET destroy" do
    before do
      set_current_user
      get :destroy      
    end
    
    it {is_expected.to set_session(nil)}      
    it {is_expected.to redirect_to root_path}      
    it {is_expected.to set_flash}
  end
end