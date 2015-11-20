require 'spec_helper'

describe UserSignup do
  describe "#sign_up" do
    context "sending emails" do
      after {ActionMailer::Base.deliveries.clear}
      let(:charge) {double(:charge, successful?: true)}
      before do
        ActionMailer::Base.deliveries.clear
        allow(StripeWrapper::Charge).to receive(:create).and_return(charge)
      end
      
      it "sends out email to the user with valid inputs" do
        UserSignup.new(Fabricate.build(:user, email: "john@example.com", password: "password", name: "john smith")).sign_up("stripetoken")
        expect(ActionMailer::Base.deliveries.last.to).to eq(["john@example.com"])
      end
      
      it "sends out email containing the user's name with valid inputs" do
        UserSignup.new(Fabricate.build(:user, email: "john@example.com", password: "password", name: "john smith")).sign_up("stripetoken")
        expect(ActionMailer::Base.deliveries.last.body).to include("john smith")
      end
      
      it "does not send out email with invalid inputs" do
        UserSignup.new(User.new(email: "john@example.com")).sign_up("stripetoken")
        expect(ActionMailer::Base.deliveries).to be_empty
      end         
    end      
    
    context "with valid personal info and valid card" do
      it "creates the user" do  
        charge = double(:charge, successful?: true)
        expect(StripeWrapper::Charge).to receive(:create).and_return(charge)
        UserSignup.new(Fabricate.build(:user)).sign_up("stripetoken")
        expect(User.count).to eq(1)
      end
    end
    
    context "with valid personal info and declined card" do      
      it "does not create a new user record" do
        charge = double(:charge, successful?: false, error_message: "Your card was declined.")
        expect(StripeWrapper::Charge).to receive(:create).and_return(charge)
        UserSignup.new(Fabricate.build(:user)).sign_up("stripetoken")            
        expect(User.count).to eq(0)
      end
    end 
    
    context "with invalid personal info" do        
      it "does not create user" do
        expect {UserSignup.new(User.new(name: "Joe", email: "Joesmith@example.com")).sign_up("stripetoken")}.to_not change {User.count}
      end      
      
      it "does not charge the card" do
        expect(StripeWrapper::Charge).not_to receive(:create)
        UserSignup.new(User.new(name: "Joe", email: "Joesmith@example.com")).sign_up("stripetoken")
      end
    end
    
    context "with valid personal info, valid card, and invitation" do
      let(:dean) {Fabricate(:user)}
      let(:invitation) {Fabricate(:invitation, inviter: dean, recipient_email: "sam@example.com")}
      let(:sam) {User.find_by(email: "sam@example.com")}
      let(:charge) {double(:charge, successful?: true)}
      before do
        expect(StripeWrapper::Charge).to receive(:create).and_return(charge)
        UserSignup.new(Fabricate.build(:user, email: "sam@example.com", password: "password", name: "sam winchester")).sign_up("stripetoken", invitation.token)
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
end