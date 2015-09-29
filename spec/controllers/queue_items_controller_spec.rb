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
      before {session[:user_id] = george.id}
      let(:item1) {Fabricate(:queue_item, user: george)}
      
      it "removes video from my_queue for signed in user" do
        delete :destroy, id: item1.id
        expect(QueueItem.count).to eq(0)
      end

      it "redirects to my queue for signed in user" do
        delete :destroy, id: item1.id
        expect(response).to redirect_to my_queue_path
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
  
end