require 'spec_helper'

feature "user registers", {js: true, vcr: true} do
  background do
    visit register_path
  end  
  
  scenario "with valid user info and valid card" do
    fill_valid_user
    fill_valid_card    
    click_button "Sign Up"
    expect(page).to have_css("div#flash_success")
  end
  
  scenario "with valid user info and invalid card" do
    fill_valid_user
    fill_invalid_card    
    click_button "Sign Up"
    expect(page).to have_content("This card number looks invalid.")
  end
  
  scenario "with valid user info and declined card" do
    fill_valid_user
    fill_declined_card    
    click_button "Sign Up"
    expect(page).to have_css("div#flash_danger")
  end
  
  scenario "with invalid user info and valid card" do
    fill_invalid_user
    fill_valid_card    
    click_button "Sign Up"
    expect(page).to have_css("div#flash_danger")
  end
  
  scenario "with invalid user info and invalid card" do
    fill_invalid_user
    fill_invalid_card    
    click_button "Sign Up"
    expect(page).to have_content("This card number looks invalid.")
  end
  
  scenario "with invalid user info and declined card" do
    fill_invalid_user
    fill_declined_card    
    click_button "Sign Up"
    expect(page).to have_css("div#flash_danger")
  end
  
  def fill_valid_user
    fill_in "Email Address", with: "logan@example.com"
    fill_in "Password", with: "password"
    fill_in "Full Name", with: "Logan"
  end
  
  def fill_invalid_user
    fill_in "Email Address", with: "logan@example.com"
    fill_in "Full Name", with: "Logan"
  end
  
  def fill_valid_card
    fill_in "Credit Card Number", with: "4242424242424242"
    fill_in "Security Code", with: "123"
    select "11 - November", from: "date_month"
    select "#{Time.now.year + 1}", from: "date_year"
  end
  
  def fill_invalid_card
    fill_in "Credit Card Number", with: "123"
    fill_in "Security Code", with: "123"
    select "11 - November", from: "date_month"
    select "#{Time.now.year + 1}", from: "date_year"
  end
  
  def fill_declined_card
    fill_in "Credit Card Number", with: "4000000000000002"
    fill_in "Security Code", with: "123"
    select "11 - November", from: "date_month"
    select "#{Time.now.year + 1}", from: "date_year"
  end  
end