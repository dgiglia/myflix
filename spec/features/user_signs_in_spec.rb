require 'spec_helper'

feature "user signs in" do
  scenario "with valid email and password" do
    jake = Fabricate(:user)
    sign_in(jake)
    expect(page).to have_content(jake.name)
  end
  
  scenario "with deactivated user" do
    jake = Fabricate(:user, active: false)
    sign_in(jake)
    expect(page).not_to have_content(jake.name)
    expect(page).to have_css("div#flash_danger")
  end
end
