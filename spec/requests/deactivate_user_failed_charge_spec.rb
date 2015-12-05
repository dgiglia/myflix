require "spec_helper"

describe "Deactivate user on failed charge" do  
  let(:event_data) do 
    {
      "id"=> "evt_17BYdDHCrQkfMpMY147wZibR",
      "object"=> "event",
      "api_version"=> "2015-10-16",
      "created"=> 1448578467,
      "data"=> {
        "object"=> {
          "id"=> "ch_17BYdCHCrQkfMpMYFlvvQ9AO",
          "object"=> "charge",
          "amount"=> 999,
          "amount_refunded"=> 0,
          "application_fee"=> nil,
          "balance_transaction"=> nil,
          "captured"=> false,
          "created"=> 1448578466,
          "currency"=> "usd",
          "customer"=> "cus_7Pi8L0ZO2FWsKN",
          "description"=> "fail charge",
          "destination"=> nil,
          "dispute"=> nil,
          "failure_code"=> "card_declined",
          "failure_message"=> "Your card was declined.",
          "fraud_details"=> {},
          "invoice"=> nil,
          "livemode"=> false,
          "metadata"=> {},
          "paid"=> false,
          "receipt_email"=> nil,
          "receipt_number"=> nil,
          "refunded"=> false,
          "refunds"=> {
            "object"=> "list",
            "data"=> [],
            "has_more"=> false,
            "total_count"=> 0,
            "url"=> "/v1/charges/ch_17BYdCHCrQkfMpMYFlvvQ9AO/refunds"
          },
          "shipping"=> nil,
          "source"=> {
            "id"=> "card_17BYbbHCrQkfMpMYqO1T3xM5",
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
            "customer"=> "cus_7Pi8L0ZO2FWsKN",
            "cvc_check"=> "pass",
            "dynamic_last4"=> nil,
            "exp_month"=> 11,
            "exp_year"=> 2016,
            "fingerprint"=> "Mfw2RO60TgcNghO5",
            "funding"=> "credit",
            "last4"=> "0341",
            "metadata"=> {},
            "name"=> nil,
            "tokenization_method"=> nil
          },
          "statement_descriptor"=> nil,
          "status"=> "failed"
        }
      },
      "livemode"=> false,
      "pending_webhooks"=> 1,
      "request"=> "req_7QPSHVTrKVPLTF",
      "type"=> "charge.failed"
    }
  end
  
  it "deactivates user with stripe web hook failed charge", :vcr do
    joann = Fabricate(:user, customer_token: "cus_7Pi8L0ZO2FWsKN")
    post "/stripe_events", event_data
    expect(joann.reload).not_to be_active
  end
end