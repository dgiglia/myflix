require 'spec_helper'

describe QueueItemsController do
  it {is_expected.to use_before_action(:require_user)}
  
  describe "GET index" do
    it "sets signed in user's queue items to @queue_items" do
      bill = Fabricate(:user)
      session[:user_id] = bill.id
      queue_item1 = Fabricate(:queue_item, user: bill)
      queue_item2 = Fabricate(:queue_item, user: bill)
      get :index
      expect(assigns(:queue_items)).to eq([queue_item1, queue_item2])
    end
    
    it "redirects to front page if unauthenticated users" do
      get :index
      expect(response).to redirect_to root_path
    end
  end
end