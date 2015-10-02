require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    it "renders new template for unauthenticated users" do
      get :new
      expect(response).not_to redirect_to home_path
    end
    it "redirects to home page for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end
  end
  
  describe "POST create" do
    context "with valid credentials" do
      let(:bob) {Fabricate(:user)}
      before {post :create, email: bob.email, password: bob.password}
      
      it {is_expected.to set_session[:user_id].to(bob.id)}      
      it {is_expected.to redirect_to home_path}      
      it {is_expected.to set_flash}
    end
    
    context "with invalid credentials" do
      let(:bob) {Fabricate(:user)}
      before {post :create, email: bob.email, password: bob.password + 'dfhhtdf'}
      
      it {is_expected.to set_session(nil)}      
      it {is_expected.to redirect_to sign_in_path}      
      it {is_expected.to set_flash}
    end
  end
  
  describe "GET destroy" do
    before do
      session[:user_id] = Fabricate(:user).id
      get :destroy      
    end
    
    it {is_expected.to set_session(nil)}      
    it {is_expected.to redirect_to root_path}      
    it {is_expected.to set_flash}
  end
end