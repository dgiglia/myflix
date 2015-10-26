require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end
  
  describe "POST create" do
    context "with valid input" do
      before {post :create, user: Fabricate.attributes_for(:user)}
      
      it "creates the user" do        
        expect(User.count).to eq(1)
      end
      
      it {is_expected.to redirect_to sign_in_path}
    end
    
    context "sending emails" do
      after {ActionMailer::Base.deliveries.clear}
      
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
      
    context "with invalid input" do
      before {post :create, user: {password: "password", name: "your name"}}
      
      it "does not create user" do        
        expect(User.count).to eq(0)
      end
      
      it {is_expected.to render_template(:new)} 
      
      it "sets @user" do
        expect(assigns(:user)).to be_instance_of(User)
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
end