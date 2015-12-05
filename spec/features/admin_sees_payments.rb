require 'spec_helper'

feature "admin sees payments" do
  background do
    daria = Fabricate(:user, name: "Daria Hogan", email: "dh@example.com")
    Fabricate(:payment, amount: 999, user: daria)
  end
  
  scenario "admin can see payments" do
    sign_in(Fabricate(:admin))
    visit admin_payments_path
    expect(page).to have_content("$9.99")
    expect(page).to have_content("Daria Hogan")
    expect(page).to have_content("dh@example.com")
  end
  
  scenario "user can not see payments" do
    sign_in(Fabricate(:user))
    visit admin_payments_path
    expect(page).not_to have_content("$9.99")
    expect(page).not_to have_content("Daria Hogan")
    expect(page).to have_css("div#flash_danger")
  end
end