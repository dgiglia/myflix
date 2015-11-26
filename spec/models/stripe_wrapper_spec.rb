require 'spec_helper'

describe "StripeWrapper" do
  let(:valid_token) do
    Stripe::Token.create(
      :card => {
        :number => "4242424242424242",
        :exp_month => 11,
        :exp_year => Time.now.year + 1,
        :cvc => "314"
      }
    ).id
  end

  let(:invalid_token) do
    Stripe::Token.create(
      :card => {
        :number => "4000000000000002",
        :exp_month => 11,
        :exp_year => Time.now.year + 1,
        :cvc => "314"
      }
    ).id
  end

  describe "StripeWrapper::Charge" do
    describe ".create" do      
      it "makes a successful charge", :vcr do
        response = StripeWrapper::Charge.create(
          amount: 999,
          card: valid_token,
          currency: "usd",
          description: "A valid charge"
        )

        expect(response).to be_successful
      end
      
      context "with an invalid charge" do        
        let(:response) {StripeWrapper::Charge.create(
            amount: 999,
            card: invalid_token,
            currency: "usd",
            description: "An invalid charge"
          )}
      
        it "makes a card declined charge", :vcr do
          expect(response).not_to be_successful
        end

        it "returns the error message for declined charges", :vcr do
          expect(response.error_message).to be_present
        end
      end
    end
  end
  
  describe "StripeWrapper::Customer" do
    let(:jen) {Fabricate(:user)}
    describe ".create" do
      context "with valid card" do
        it "creates a customer", :vcr do
          response = StripeWrapper::Customer.create(
            user: jen,
            card: valid_token,
          )
          expect(response).to be_successful 
        end
        
        it "returns the customer token", :vcr do
          response = StripeWrapper::Customer.create(
            user: jen,
            card: valid_token,
          )
          expect(response.customer_token).to be_present
        end
      end
      
      context "with declined card" do
        let(:response) {StripeWrapper::Customer.create(
          user: jen,
          card: invalid_token,
        )}
        
        it "does not create a customer", :vcr do
          expect(response).not_to be_successful
        end

        it "returns the error message for declined charges", :vcr do
          expect(response.error_message).to be_present
        end
      end
    end
  end
end