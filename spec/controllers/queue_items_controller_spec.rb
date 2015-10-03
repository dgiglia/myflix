require 'spec_helper'

describe QueueItemsController do
  it {is_expected.to use_before_action(:require_user)}
  
  describe "GET index" do
    it "sets signed in user's queue items to @queue_items" do
      bill = Fabricate(:user)
      session[:user_id] = bill.id
      queue_item1 = Fabricate(:queue_item, user: bill, position: 1)
      queue_item2 = Fabricate(:queue_item, user: bill, position: 2)
      get :index
      expect(assigns(:queue_items)).to eq([queue_item1, queue_item2])
    end
    
    it "redirects to front page if unauthenticated users" do
      get :index
      expect(response).to redirect_to root_path
    end
  end
  
  describe "POST create" do
    context "with authenticated user" do
      let(:chopper) {Fabricate(:video)}
      let(:john) {Fabricate(:user)}
      before do
        session[:user_id] = john.id
      end
      
      it "redirect to my queue page" do
        post :create, video_id: chopper.id
        expect(response).to redirect_to my_queue_path
      end

      it "create a queue item" do
        post :create, video_id: chopper.id
        expect(QueueItem.count).to eq(1)
      end
      
      it "creates queue item that is associated with the video" do
        post :create, video_id: chopper.id
        expect(QueueItem.first.video).to eq(chopper)
      end
      
      it "creates queue item that is associated with the signed in user" do
        post :create, video_id: chopper.id
        expect(QueueItem.first.user).to eq(john)
      end
      
      it "puts the video as last in queue" do
        post :create, video_id: chopper.id
        stork = Fabricate(:video)
        post :create, video_id: stork.id
        stork_queue_item = QueueItem.find_by(video_id: stork.id, user_id: john.id)
        expect(stork_queue_item.position).to eq(2)
      end
      
      it "does not add video if already in queue" do
        Fabricate(:queue_item, video: chopper, user: john)
        post :create, video_id: chopper.id
        expect(john.queue_items.count).to eq(1)
      end
    end
    
    context "with unauthenticated user" do
      before {post :create}
      it {is_expected.to redirect_to root_path}
    end
  end
  
  describe "DELETE destroy" do
    context "with authenticated user" do
      let(:george) {Fabricate(:user)}
      let(:item1) {Fabricate(:queue_item, user: george, position: 1)}
      before {session[:user_id] = george.id}
      
      it "removes video from my_queue for signed in user" do
        delete :destroy, id: item1.id
        expect(QueueItem.count).to eq(0)
      end

      it "redirects to my queue for signed in user" do
        delete :destroy, id: item1.id
        expect(response).to redirect_to my_queue_path
      end
      
      it "normalizes remaining queue items" do
        item2 = Fabricate(:queue_item, user: george, position: 2)
        delete :destroy, id: item1.id
        expect(item2.reload.position).to eq(1)
      end

      it "does not delete item if it is not in current user's queue" do
        susie = Fabricate(:user)
        session[:user_id] = susie.id
        delete :destroy, id: item1.id
        expect(george.queue_items.count).to eq(1)
      end
    end
    
    context "with unauthenticated user" do
      let(:item) {Fabricate(:queue_item)}
      before {delete :destroy, id: item.id}
      
      it {is_expected.to redirect_to root_path}
    end
  end
  
  describe "POST update_queue" do    
    context "with valid input" do
      let(:renee) {Fabricate(:user)}
      let(:video) {Fabricate(:video)}
      let(:item_alpha) {Fabricate(:queue_item, user: renee, position: 1, video: video)}
      let(:item_beta) {Fabricate(:queue_item, user: renee, position: 2, video: video)}
      before {session[:user_id] = renee.id}
      
      it "redirects to my queue page" do
        post :update_queue, queue_items: [{id: item_alpha.id, position: 2}, {id: item_beta.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end
      
      it "reorders queue items" do
        post :update_queue, queue_items: [{id: item_alpha.id, position: 2}, {id: item_beta.id, position: 1}]
        expect(renee.queue_items).to eq([item_beta, item_alpha])
      end
      
      it "normalizes the position numbers" do
        post :update_queue, queue_items: [{id: item_alpha.id, position: 3}, {id: item_beta.id, position: 2}]
        expect(renee.queue_items.map(&:position)).to eq([1, 2])
      end
    end
    
    context "with invalid input" do
      let(:renee) {Fabricate(:user)}
      let(:video) {Fabricate(:video)}
      let(:item_alpha) {Fabricate(:queue_item, user: renee, position: 1, video: video)}
      let(:item_beta) {Fabricate(:queue_item, user: renee, position: 2, video: video)}
      before do 
        session[:user_id] = renee.id
        post :update_queue, queue_items: [{id: item_alpha.id, position: 3}, {id: item_beta.id, position: "B"}]
      end
      
      it {is_expected.to redirect_to my_queue_path}      
      it {is_expected.to set_flash['danger']}
      
      it "does not change queue items" do
        expect(item_alpha.reload.position).to eq(1)
        expect(item_beta.reload.position).to eq(2)
      end
    end
    
    context "with unauthenticated user" do
      it "redirects to the front page" do
        post :update_queue, queue_items: [{id: 1, position: 3}, {id: 2, position: 5}]
        expect(response).to redirect_to root_path
      end
    end
    
    context "with queue items that do not belong to current user" do
      it "does not change queue items" do
        renee = Fabricate(:user)
        bob = Fabricate(:user)
        video = Fabricate(:video)
        session[:user_id] = renee.id
        item_alpha = Fabricate(:queue_item, user: bob, position: 1, video: video)
        item_beta = Fabricate(:queue_item, user: bob, position: 2, video: video)
        post :update_queue, queue_items: [{id: item_alpha.id, position: 2}]
        expect(item_alpha.reload.position).to eq(1)
      end
    end
  end
  
end