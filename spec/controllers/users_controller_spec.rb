require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end
  

  
  describe "POST create" do
    context "with successful sign up" do
      let(:result) {double(:sign_up_result, successful?: true)}  
      before do
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
      end
      it {is_expected.to set_flash[:success]}
      it {is_expected.to redirect_to sign_in_path}         
    end    
    
    context "with failed sign up" do
      let(:result) {double(:sign_up_result, successful?: false, error_message: "Your card was declined.")}
      before do
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
      end      
      it "sets @user" do
        expect(assigns(:user)).to be_instance_of(User)
      end
      it {is_expected.to render_template(:new)}      
      it {is_expected.to set_flash.now[:danger]}
    end       
  end
  
  describe "GET show" do
    it_behaves_like "require sign in" do
      let(:action) {get :show, id: 2}
    end
    
    it "sets @user" do
      set_current_user
      john = Fabricate(:user)
      get :show, id: john.id
      expect(assigns(:user)).to eq(john)
    end    
  end
  
  describe "GET new_with_invitation_token" do
    let(:invitation) {Fabricate(:invitation)}
    after {ActionMailer::Base.deliveries.clear}
    
    it "sets @user with recipient's email" do
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email).to eq(invitation.recipient_email)
    end
    
    it "renders new template" do
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template(:new)
    end 
    
    it "redirects to expired token page for invlaid tokens" do
      get :new_with_invitation_token, token: 'sodifhdoxkjvnklnvc'
      expect(response).to redirect_to expired_token_path
    end   
    
    it "sets @invitation_token" do
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end
  end
end