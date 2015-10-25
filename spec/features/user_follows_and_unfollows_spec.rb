require 'spec_helper'

feature "user follows and unfollows" do
  scenario "user adds and removes another to following list" do
    leader = Fabricate(:user)
    comedy = Fabricate(:category)
    video = Fabricate(:video, category: comedy)
    Fabricate(:review, user: leader, video: video)
    
    sign_in
    visit home_path
    click_video_link(video)
    click_link(leader.name)
    click_link("Follow")
    visit people_path
    expect(page).to have_content(leader.name)
    
    unfollow(leader) 
    visit people_path
    expect(page).not_to have_content(leader.name)        
  end
  
  def unfollow(user)
    find("a[data-method='delete']").click
  end
end