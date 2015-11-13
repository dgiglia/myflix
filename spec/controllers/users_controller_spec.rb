require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end
  
  describe "POST create" do
    context "sending emails" do
      after {ActionMailer::Base.deliveries.clear}
      let(:charge) {double(:charge, successful?: true)}
      before do
        ActionMailer::Base.deliveries.clear
        StripeWrapper::Charge.stub(:create).and_return(charge)
      end
      
      it "sends out email to the user with valid inputs" do
        post :create, user: {email: "john@example.com", password: "password", name: "john smith"}
        expect(ActionMailer::Base.deliveries.last.to).to eq(["john@example.com"])
      end
      
      it "sends out email containg the user's name with valid inputs" do
        post :create, user: {email: "john@example.com", password: "password", name: "john smith"}
        expect(ActionMailer::Base.deliveries.last.body).to include("john smith")
      end
      
      it "does not send out email with invalid inputs" do
        post :create, user: {email: "john@example.com", name: "john smith"}
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
    
    context "with valid personal info and valid card" do
      let(:charge) {double(:charge, successful?: true)}
      before do
        StripeWrapper::Charge.stub(:create).and_return(charge)
        post :create, user: Fabricate.attributes_for(:user)
      end
      
      it "creates the user" do        
        expect(User.count).to eq(1)
      end
      
      it {is_expected.to redirect_to sign_in_path}         
    end    
    
    context "with valid personal info and declined card" do
      let(:charge) {double(:charge, successful?: false, error_message: "Your card was declined.")}
      before do
        StripeWrapper::Charge.stub(:create).and_return(charge)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '123123'
      end
      
      it "does not create a new user record" do
        expect(User.count).to eq(0)
      end
      
      it {is_expected.to render_template(:new)}
      
      it {is_expected.to set_flash.now[:danger]}
    end    
    
    context "with invalid personal info" do
      before {post :create, user: {password: "password", name: "your name"}}
      
      it "does not create user" do        
        expect(User.count).to eq(0)
      end
      
      it {is_expected.to render_template(:new)} 
      
      it "sets @user" do
        expect(assigns(:user)).to be_instance_of(User)
      end
      
      it "does not charge the card" do
        expect(StripeWrapper::Charge).not_to receive(:create)
      end
    end
    
    context "with valid personal info, valid card, and invitation" do
      let(:dean) {Fabricate(:user)}
      let(:invitation) {Fabricate(:invitation, inviter: dean, recipient_email: "sam@example.com")}
      let(:sam) {User.find_by(email: "sam@example.com")}
      let(:charge) {double(:charge, successful?: true)}
      before do
        StripeWrapper::Charge.stub(:create).and_return(charge)
        post :create, user: {email: "sam@example.com", password: "password", name: "sam winchester"}, invitation_token: invitation.token
      end
      after {ActionMailer::Base.deliveries.clear}
      
      it "makes the user follow the inviter" do        
        expect(sam.follows?(dean)).to be true
      end
      
      it "makes the inviter follow the user" do
        expect(dean.follows?(sam)).to be true
      end
      
      it "expires the invitation upon acceptance" do
        expect(Invitation.first.token).to be nil
      end
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