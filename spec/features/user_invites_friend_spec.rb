require 'spec_helper'

feature "User invites friend" do
  scenario "user successfully invites friend and invitation is accepted" do
    dean = Fabricate(:user)
    sign_in(dean)
    invite_cas    
    cas_accepts_invitation
    cas_signs_in     
    cas_should_follow(dean)
    cas_should_be_followed_by(dean)
    clear_email
  end
  
  def invite_cas
    visit new_invitation_path
    fill_in "Friend's Name", with: "Castiel"
    fill_in "Friend's Email Address", with: "cas@example.com"
    fill_in "Invitation Message", with: "Sam and Dean have prayed for you to join them."
    click_button "Send Invitation"
    sign_out
  end
  
  def cas_accepts_invitation
    open_email "cas@example.com"
    current_email.click_link "Accept this invitation"
    
    fill_in "Password", with: "password"
    fill_in "Full Name", with: "Castiel"
    click_button "Submit"
  end
  
  def cas_signs_in
    fill_in "Email Address", with: "cas@example.com"
    fill_in "Password", with: "password"
    click_button "Submit"
  end
  
  def cas_should_follow(dean)
    click_link "People"
    expect(page).to have_content dean.name
    sign_out
  end
  
  def cas_should_be_followed_by(dean)
    sign_in(dean)
    click_link "People"
    expect(page).to have_content("Castiel")
  end
end