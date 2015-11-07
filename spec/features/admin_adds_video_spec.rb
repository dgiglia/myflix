require 'spec_helper'

feature "admin adds new video" do
  scenario "admin successfully adds new video" do
    admin = Fabricate(:admin)
    drama = Fabricate(:category, name: "Drama")
    
    sign_in(admin)
    visit new_admin_video_path
    fill_in "Title", with: "Blob"
    select "Drama", from: "Category"
    fill_in "Description", with: "Best drama of the year"
    attach_file "Large cover", "spec/support/uploads/monk.jpg"
    attach_file "Small cover", "spec/support/uploads/monksmall.jpg"
    fill_in "Video url", with: "http://example.com/myvid.mp4"
    click_button "Add Video"
    sign_out
    
    sign_in
    visit video_path(Video.first)
    expect(page).to have_selector("img[src='/uploads/monk.jpg']")
    expect(page).to have_selector("a[href='http://example.com/myvid.mp4']")
  end
end
