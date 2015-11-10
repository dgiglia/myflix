require 'spec_helper'

describe "StripeWrapper" do
  describe "StripeWrapper::Charge" do
    describe ".create" do      
      it "makes a sucessful charge", :vcr do
        Stripe.api_key = ENV['STRIPE_SECRET_KEY']
        token = Stripe::Token.create(
          :card => {
            :number => "4242424242424242",
            :exp_month => 11,
            :exp_year => 2020,
            :cvc => "314"
            },
        ).id

        response = Stripe::Charge.create(
          amount: 999,
          card: token,
          currency: "usd",
          description: "A valid charge"
        )

        expect(response.amount).to eq(999)
        expect(response.currency).to eq("usd")
      end
    end
  end
end