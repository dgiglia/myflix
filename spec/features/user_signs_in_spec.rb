require 'spec_helper'

feature "user signs in" do
  scenario "with valid email and password" do
    jake = Fabricate(:user)
    sign_in(jake)
    page.should have_content(jake.name)
  end
end
