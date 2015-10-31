require "spec_helper"

describe Invitation do
  it { is_expected.to belong_to(:inviter).class_name('User') }
  it { is_expected.to validate_presence_of(:recipient_name) }
  it { is_expected.to validate_presence_of(:recipient_email) }
  it { is_expected.to validate_presence_of(:message) }
end