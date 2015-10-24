class User < ActiveRecord::Base
  has_secure_password validations: false
  has_many :reviews, -> {order("created_at DESC")}
  has_many :queue_items, -> {order("position")}
  
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
end