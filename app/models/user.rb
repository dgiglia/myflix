class User < ActiveRecord::Base
  include Tokenable
  
  has_secure_password validations: false
  has_many :reviews, -> {order("created_at DESC")}
  has_many :queue_items, -> {order("position")}
  has_many :following_relationships, class_name: "Relationship", foreign_key: "follower_id"
  has_many :leading_relationships, class_name: "Relationship", foreign_key: "leader_id"
  has_many :payments
  
  validates_presence_of :email, :password, :name
  validates_uniqueness_of :email 
    
  def normalize_queue_positions
    queue_items.each_with_index do |q, i|
      q.update_attributes(position: i+1)
    end
  end
  
  def queued_video?(video)
    queue_items.map(&:video).include?(video)
  end
    
  def follows?(another_user)
    following_relationships.map(&:leader).include?(another_user)
  end
  
  def can_follow?(another_user)
    !(self.follows?(another_user) || another_user == self)
  end
  
  def follow(another_user)
    following_relationships.create(leader: another_user) if can_follow?(another_user)
  end
  
  def deactivate!
    update_column(:active, false)
  end
end