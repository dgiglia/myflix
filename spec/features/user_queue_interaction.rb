require 'spec_helper'

feature "user signs in" do
  scenario "user adds and reorders videos in queue" do
    comedy = Fabricate(:category)
    shield = Fabricate(:video, title: "Shield", category: comedy)
    big_bang = Fabricate(:video, title: "Big Bang", category: comedy)
    star_trek = Fabricate(:video, title: "Star Trek", category: comedy)
    
    sign_in
    
    add_video_to_queue(shield)
    expect(page).to have_content(shield.title)
    
    visit video_path(shield)
    expect(page).not_to have_content "+ My Queue"
    
    add_video_to_queue(big_bang)
    add_video_to_queue(star_trek)
    
    set_video_position(shield, 3)
    set_video_position(big_bang, 1)
    set_video_position(star_trek, 2)
    
    click_button "Update Instant Queue"
    
    expect_video_position(shield, 3)
    expect_video_position(big_bang, 1)
    expect_video_position(star_trek, 2)
  end
  
  def expect_video_position(video, position)
    expect(find("input[data-video-id='#{video.id}']").value).to eq(position.to_s)
  end
  
  def set_video_position(video, position)
    find("input[data-video-id='#{video.id}']").set(position)
  end
  
  def add_video_to_queue(video)
    visit home_path
    find("a[href='/videos/#{video.id}']").click
    click_link "+ My Queue"
  end
end
