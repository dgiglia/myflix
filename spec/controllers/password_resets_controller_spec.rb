require 'spec_helper'

describe PasswordResetsController do  
  describe "GET show" do
    it "renders the show template if the token is valid" do
      user = Fabricate(:user)
      get :show, id: user.token
      expect(response).to render_template :show
    end

    it "sets @token" do
      user = Fabricate(:user)
      user.update_column(:token, '12345')
      get :show, id: 12345
      expect(assigns(:token)).to eq('12345')
    end

    it "redirects to the expired token page if the token is not valid" do
      get :show, id: 12345
      expect(response).to redirect_to expired_token_path
    end
  end
  
  describe "POST create" do
    context "with valid token" do
      let(:user) {Fabricate(:user, password: 'password')}
      before do
        user.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_password'
      end
      
      it "updates user's password" do
        expect(user.reload.authenticate('new_password')).to be_truthy
      end
      
      it "regenerates the user's token" do
        expect(user.reload.token).not_to eq('12345')
      end
      
      it {is_expected.to redirect_to sign_in_path}
      
      it {is_expected.to set_flash[:success]}
    end
    
    context "with invalid token" do
      before {post :create, token: '12345', password: 'some_password'}
      it {is_expected.to redirect_to sign_in_path}
    end    
  end
end