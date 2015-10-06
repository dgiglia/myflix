require 'spec_helper'

feature "user signs in" do
  scenario "with valid email and password" do
    jake = Fabricate(:user)
    visit(sign_in_path)
    fill_in("Email Address", with: jake.email)
    fill_in("Password", with: jake.password)
    click_button("Submit")
    page.should have_content(jake.name)
  end
end
