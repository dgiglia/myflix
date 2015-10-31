require 'spec_helper'

describe InvitationsController do  
  it {is_expected.to use_before_action(:require_user)}
  
  describe "GET new" do
    it "sets @invitation to a new invitation" do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_new_record
      expect(assigns(:invitation)).to be_instance_of Invitation
    end
    
    it_behaves_like "require sign in" do
      let(:action) {get :new}
    end
  end
  
  describe "POST create" do
    it_behaves_like "require sign in" do
      let(:action) {post :create}
    end
    
    context "with valid input" do
      before do
        set_current_user
        post :create, invitation: {recipient_name: "joey", recipient_email: "joey@example.com", message: "Please join!"}
      end
      after {ActionMailer::Base.deliveries.clear}
      
      it "creates an invitation" do
        expect(Invitation.count).to eq(1)
      end
      
      it "send an email to the recipient" do
        expect(ActionMailer::Base.deliveries.last.to).to eq(["joey@example.com"])
      end
      
      it {is_expected.to redirect_to new_invitation_path}   
      
      it {is_expected.to set_flash['success']}
    end
    
    context "with invalid input" do
      before do
        set_current_user
        post :create, invitation: {recipient_email: "joey@example.com", message: "Please join!"}
      end
      after {ActionMailer::Base.deliveries.clear}
      
      it "does not create an invitation" do
        expect(Invitation.count).to eq(0)
      end
      
      it "does not send out an email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
      
      it "sets @invitation" do
        expect(assigns(:invitation)).to be_present
      end
      
      it {is_expected.to render_template(:new)}   
      
      it {is_expected.to set_flash['danger']}
    end
  end
end