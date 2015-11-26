require "spec_helper"

describe "Create payment on successful charge" do  
  let(:event_data) do 
    {
      "id"=> "evt_17As34HCrQkfMpMYy2M7Gdvf",
      "object"=> "event",
      "api_version"=> "2015-10-16",
      "created"=> 1448414778,
      "data"=> {
        "object"=> {
          "id"=> "ch_17As34HCrQkfMpMYzHI6J694",
          "object"=> "charge",
          "amount"=> 999,
          "amount_refunded"=> 0,
          "application_fee"=> nil,
          "balance_transaction"=> "txn_17As34HCrQkfMpMYbfIRVlxv",
          "captured"=> true,
          "created"=> 1448414778,
          "currency"=> "usd",
          "customer"=> "cus_7PhR6SWtjqoTYd",
          "description"=> nil,
          "destination"=> nil,
          "dispute"=> nil,
          "failure_code"=> nil,
          "failure_message"=> nil,
          "fraud_details"=> {},
          "invoice"=> "in_17As34HCrQkfMpMYn3Tvk4qY",
          "livemode"=> false,
          "metadata"=> {},
          "paid"=> true,
          "receipt_email"=> nil,
          "receipt_number"=> nil,
          "refunded"=> false,
          "refunds"=> {
            "object"=> "list",
            "data"=> [],
            "has_more"=> false,
            "total_count"=> 0,
            "url"=> "/v1/charges/ch_17As34HCrQkfMpMYzHI6J694/refunds"
          },
          "shipping"=> nil,
          "source"=> {
            "id"=> "card_17As33HCrQkfMpMY47mdBmhn",
            "object"=> "card",
            "address_city"=> nil,
            "address_country"=> nil,
            "address_line1"=> nil,
            "address_line1_check"=> nil,
            "address_line2"=> nil,
            "address_state"=> nil,
            "address_zip"=> nil,
            "address_zip_check"=> nil,
            "brand"=> "Visa",
            "country"=> "US",
            "customer"=> "cus_7PhR6SWtjqoTYd",
            "cvc_check"=> "pass",
            "dynamic_last4"=> nil,
            "exp_month"=> 11,
            "exp_year"=> 2015,
            "fingerprint"=> "BB3tXPVjt1y5XYSy",
            "funding"=> "credit",
            "last4"=> "4242",
            "metadata"=> {},
            "name"=> nil,
            "tokenization_method"=> nil
          },
          "statement_descriptor"=> nil,
          "status"=> "succeeded"
        }
      },
      "livemode"=> false,
      "pending_webhooks"=> 1,
      "request"=> "req_7PhRpJ0aeWYYaA",
      "type"=> "charge.succeeded"
    }
  end
  
  it "creates a payment with stripe webhook for cvharge succeeded", :vcr do  
    post "/stripe_events", event_data
    expect(Payment.count).to eq(1)
  end
  
  it "creates the payment associated with the user", :vcr do
    joann = Fabricate(:user, customer_token: "cus_7PhR6SWtjqoTYd")
    post "/stripe_events", event_data
    expect(Payment.first.user).to eq(joann)
  end
  
  it "creates the payment with the amount", :vcr do
    joann = Fabricate(:user, customer_token: "cus_7PhR6SWtjqoTYd")
    post "/stripe_events", event_data
    expect(Payment.first.amount).to eq(999)
  end
  
  it "creates the payment with reference id", :vcr do
    joann = Fabricate(:user, customer_token: "cus_7PhR6SWtjqoTYd")
    post "/stripe_events", event_data
    expect(Payment.first.reference_id).to eq("ch_17As34HCrQkfMpMYzHI6J694")
  end
end