require 'spec_helper'

describe RelationshipsController do
  it {is_expected.to use_before_action(:require_user)}
  
  describe "GET index" do
    it "sets @relationships to current users following relationships" do
      gloria = Fabricate(:user)
      set_current_user
      relationship = Fabricate(:relationship, follower: current_user, leader: gloria)
      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end
    
    it_behaves_like "require sign in" do
      let(:action) {get :index}
    end
  end
  
  describe "POST create" do
    let(:gloria) {Fabricate(:user)}
    let(:john) {current_user}
    before {set_current_user}
    
    it "redirects to people page" do
      post :create, leader_id: gloria.id
      expect(response).to redirect_to people_path
    end
    
    it_behaves_like "require sign in" do
      let(:action) {post :create, leader_id: 3}
    end
    
    it "creates a relationsip with the current_user as the follower" do
      post :create, leader_id: gloria.id
      expect(john.following_relationships.first.leader).to eq(gloria)
    end
    
    it "does not create a relationship if the current user already follows that leader" do
      relationship2 = Fabricate(:relationship, leader: gloria, follower: john)
      post :create, leader_id: gloria.id
      expect(john.following_relationships.count).to eq(1)
    end
    
    it "does not allow user to follow himself" do
      post :create, leader_id: john.id
      expect(john.following_relationships.count).to eq(0)
    end
  end
  
  describe "DELETE destroy" do
    let(:gloria) {Fabricate(:user)}
    let(:john) {current_user}
    let(:relationship) {Fabricate(:relationship, follower: john, leader: gloria)}
    before {set_current_user}
    
    it "redirects to people page" do
      delete :destroy, id: relationship
      expect(response).to redirect_to people_path
    end
    
    it "deletes relationship if current user is follower" do
      delete :destroy, id: relationship
      expect(john.following_relationships.count).to eq(0)
    end
    
    it "does not delete relationship if current user is leader" do
      relationship2 = Fabricate(:relationship, follower: gloria, leader: john)
      delete :destroy, id: relationship2
      expect(john.leading_relationships.count).to eq(1)
    end
    
    it_behaves_like "require sign in" do
      let(:action) {delete :destroy, id: 4}
    end
  end
end