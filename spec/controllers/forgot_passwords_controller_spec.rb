require 'spec_helper'

describe ForgotPasswordsController do  
  describe "POST create" do
    after {ActionMailer::Base.deliveries.clear}
    context "with blank input" do
      before {post :create, email: ""}
      
      it {is_expected.to redirect_to forgot_password_path}
      
      it {is_expected.to set_flash[:danger]}
    end
    
    context "with existing email" do
      before do 
        Fabricate(:user, email: 'joe@example.com') 
        post :create, email: 'joe@example.com' 
      end

      it "redirects to the forgot password confirmation page" do
        expect(response).to redirect_to forgot_password_confirmation_path
      end

      it "sends out an email to the email address" do
        expect(ActionMailer::Base.deliveries.last.to).to eq(['joe@example.com'])
      end
    end
 
    
    context "with non-existing email" do
      before {post :create, email: "shiba@example.com"}
      
      it {is_expected.to redirect_to forgot_password_path}
      
      it {is_expected.to set_flash[:danger]}
    end
  end
end