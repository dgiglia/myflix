require 'spec_helper'

feature "User invites friend"  do
  scenario "user successfully invites friend and invitation is accepted", {js: true, vcr: true} do 
    user = Fabricate(:user)
    sign_in(user)
    invite_invitee    
    invitee_accepts_invitation
    invitee_signs_in     
    invitee_should_follow(user)
    invitee_should_be_followed_by(user)
    clear_emails
  end
  
  def invite_invitee
    visit new_invitation_path
    fill_in "Friend's Name", with: "Castiel"
    fill_in "Friend's Email Address", with: "invitee@example.com"
    fill_in "Invitation Message", with: "Sam and Dean have prayed for you to join them."
    click_button "Send Invitation"
    sign_out
  end
  
  def invitee_accepts_invitation
    open_email "invitee@example.com"
    current_email.click_link "Accept this invitation"
    
    fill_in "Password", with: "password"
    fill_in "Full Name", with: "Castiel"
    fill_in "Credit Card Number", with: "4242424242424242"
    fill_in "Security Code", with: "123"
    select "11 - November", from: "date_month"
    select "#{Time.now.year + 1}", from: "date_year"
    click_button "Sign Up"
    expect(page).to have_content("Profile was successfully created. Please sign in.")
  end
  
  def invitee_signs_in
    fill_in "Email Address", with: "invitee@example.com"
    fill_in "Password", with: "password"
    click_button "Submit"
    expect(page).to have_content("You're signed in.")
  end
  
  def invitee_should_follow(user)
    click_link "People"
    expect(page).to have_content(user.name)
    sign_out
  end
  
  def invitee_should_be_followed_by(user)
    sign_in(user)
    click_link "People"
    expect(page).to have_content("Castiel")
  end
end