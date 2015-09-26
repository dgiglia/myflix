require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    it "renders new template for unauthenticated users" do
      get :new
      expect(response). to render_template :new
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
      
      it "puts signed in user in session" do
        expect(session[:user_id]).to eq(bob.id)
      end
      
      it "redirects to home page" do
        expect(response).to redirect_to home_path
      end
      
      it "sets the notice" do
        expect(flash['success']).not_to be_blank
      end
    end
    
    context "with invalid credentials" do
      let(:bob) {Fabricate(:user)}
      before {post :create, email: bob.email, password: bob.password + 'dfhhtdf'}
      
      it "does not put user in session" do
        expect(session[:user_id]).to be_nil
      end
      
      it "redirects to sign in page" do
        expect(response).to redirect_to sign_in_path
      end
      
      it "sets the error message" do
        expect(flash['danger']).not_to be_blank
      end
    end
  end
  
  describe "GET destroy" do
    before do
      session[:user_id] = Fabricate(:user).id
      get :destroy      
    end
    
    it "clears session" do
      expect(session[:user_id]).to be_nil
    end
    
    it "sets the notice" do
      expect(flash['success']).not_to be_blank
    end
    
    it "redirects to root path" do
      expect(response).to redirect_to root_path
    end
  end
end