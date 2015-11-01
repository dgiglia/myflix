require 'spec_helper'

feature "user resets password" do
  scenario "user successfully resets password" do
    jane = Fabricate(:user, password: 'old_password', )
    
    visit sign_in_path
    click_link "Forgot Password?"
    fill_in "Email Address:", with: jane.email
    click_button "Send Email"
    
    open_email(jane.email)
    current_email.click_link("Reset My Password")
    
    fill_in "New Password", with: "new_password"
    click_button "Reset Password"
    
    fill_in "Email Address", with: jane.email
    fill_in "Password", with: "new_password"
    click_button "Submit"
    
    expect(page).to have_content("Welcome, #{jane.name}")
    
    clear_email
  end
end